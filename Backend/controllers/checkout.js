const jwt = require("jsonwebtoken");
const User = require("../models/user");
const Product = require("../models/product");
const orderController = require("./order");
const emailSender = require("../helpers/order_complete_email_sender");
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

exports.checkOut = async (req, res) => {
  const accessToken = req.headers["authorization"].replace("Bearer ", "").trim();
  const tokenData = jwt.decode(accessToken);
  const user = await User.findById(tokenData.id);
  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }
  for (const cartItem of req.body.cartItems) {
    const product = await Product.findById(cartItem.productId);
    if (!product) {
      return res.status(404).json({ message: ` ${cartItem.productName} not found` });
    } else if (cartItem.reserved && product.countInStock < cartItem.quantity) {
      return res.status(400).json({ message: `Not enough stock for ${cartItem.productName}` });
    }
  }

  let customerId;
  if (user.customerPaymentId) {
    customerId = user.customerPaymentId;
  } else {
    const customer = await stripe.customers.create({
      metadata: { userId: tokenData.id },
    });
    customerId = customer.id;
  }
  const session = await stripe.checkout.sessions.create({
    line_items: req.body.cartItems.map((item) => ({
      price_data: {
        currency: "usd",
        product_data: {
          name: item.productName,

          images: [item.productImage],
          metadata: {
            productId: item.productId,
            cartItemId: item.cartProductId,
            selectedColor: item.selectedColor ?? undefined,
            selectedSize: item.selectedSize ?? undefined,
          },
        },
        unit_amount: Math.round(item.productPrice * 100),
      },
      quantity: item.quantity,
    })),
    payment_method_options: {
      card: { setup_future_usage: "on_session" },
    },
    billing_address_collection: "auto",
    shipping_address_collection: {
      allowed_countries: ["KH"],
    },
    phone_number_collection: {
      enabled: true,
    },
    customer: customerId,
    mode: "payment",
    success_url: `${process.env.API_URL}/checkout/success`,
    cancel_url: `${process.env.API_URL}/checkout/cancel`,
  });
  res.status(200).json({ url: session.url });
};

exports.webHook = async (req, res) => {
  const sig = req.headers["stripe-signature"];
  let event;
  try {
    event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
  } catch (err) {
    console.error("Webhook signature verification failed:", err.message);
    return res.status(400).json({ message: `Webhook Error: ${err.message}` });
  }
  if (event.type === "checkout.session.completed") {
    const session = event.data.object;
    stripe.customers
      .retrieve(session.customer)
      .then(async (customer) => {
        const lineItems = await stripe.checkout.sessions.listLineItems(session.id, {
          expand: ["data.price.product"],
        });
        const orderItems = lineItems.data.map((item) => ({
          quantity: item.quantity,
          product: item.price.product.metadata.productId,
          cartProductId: item.price.product.metadata.cartProductId,
          productPrice: item.price.unit_amount / 100,
          productName: item.price.product.name,
          productImage: item.price.product.images[0],
          selectedColor: item.price.product.metadata.selectedColor ?? undefined,
          selectedSize: item.price.product.metadata.selectedSize ?? undefined,
        }));
        const address = session.shipping_details?.address ?? session.customer_details?.address;
        const order = await orderController.addOrder({
          orderItems: orderItems,
          shippingAddress: address.line1 === "N/A" ? address.line2 : address.line1,
          city: address.city,
          postalCode: address.postal_code,
          country: address.country,
          phone: session.customer_details?.phone ?? session.shipping_details?.phone,
          totalPrice: session.amount_total / 100,
          user: customer.metadata.userId,
          paymentId: session.payment_intent,
        });
        let user = await User.findById(customer.metadata.userId);
        if (user && !user.customerPaymentId) {
          user = await User.findByIdAndUpdate(
            customer.metadata.userId,
            { customerPaymentId: session.customer },
            { new: true },
          );
        }
        const leanOrder = order.toObject();
        leanOrder["orderItems"] = orderItems;
        await emailSender.sendOrderCompleteEmail(user.email, user.name, leanOrder, user.name);
      })
      .catch((err) => {
        console.error("Error processing checkout session:", err);
      });
  } else {
    console.log(`Unhandled event type ${event.type}`);
  }
  res.status(200).json({ received: true });
};
