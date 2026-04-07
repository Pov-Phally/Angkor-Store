const { default: mongoose } = require("mongoose");
const User = require("../models/user");
const Product = require("../models/product");
const CartProduct = require("../models/cart_product");
const OrderItem = require("../models/order_item");
const Order = require("../models/order");

exports.addOrder = async (orderData) => {
  if (!mongoose.Types.ObjectId.isValid(orderData.user)) {
    return console.error("Invalid user ID");
  }
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const user = await User.findById(orderData.user).session(session);
    if (!user) {
      await session.abortTransaction();
      return console.trace("User not found");
    }
    const orderItems = orderData.orderItems;
    const orderItemIds = [];
    for (const orderItem of orderItems) {
      if (
        !mongoose.Types.ObjectId.isValid(orderItem.product) ||
        !(await Product.findById(orderItem.product))
      ) {
        await session.abortTransaction();
        return console.trace("Invalid product ID in order item");
      }
      const product = await Product.findById(orderItem.product).session(session);

      const cartProduct = await CartProduct.findById(orderItem.cartProductId).session(session);
      if (!cartProduct) {
        await session.abortTransaction();
        return console.trace("Cart product not found for order item");
      }
      let orderItemModel = await new OrderItem({ orderItem }).save.session(session);
      if (!orderItemModel) {
        await session.abortTransaction();
        return console.trace("Failed to create order item");
      }
      if (!cartProduct.reserved) {
        product.countInStock -= orderItemModel.quantity;
        await product.save({ session });
      }
      orderItemIds.push(orderItemModel._id);
      await CartProduct.findByIdAndDelete(orderItem.cartProductId).session(session);
      user.cart.pull(cartProduct._id);
      await user.save({ session });
    }
    orderData["orderItems"] = orderItemIds;
    let order = new Order(orderData);
    order.status = "Paid";
    order.statusHistory.push("Paid");
    await order.save({ session });
    if (!order) {
      await session.abortTransaction();
      return console.trace("Failed to create order");
    }
    await session.commitTransaction();
    return order;
  } catch (error) {
    await session.abortTransaction();
    console.error("Error adding order:", error);
  } finally {
    await session.endSession();
  }
};
exports.getUserOrders = async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.params.userId })
      .select("orderitems orderDate totalPrice status")
      .populate({
        path: "orderItems",
        select: "productName productImage productPrice",
      })
      .sort({ orderDate: -1 });
    if (!orders || orders.length === 0) {
      return res.status(404).json({ error: "No orders found for this user." });
    }
    const completed = [];
    const active = [];
    const cancelled = [];
    for (const order of orders) {
      if (order.status === "Paid" || order.status === "Shipped" || order.status === "Delivered") {
        completed.push(order);
      } else if (order.status === "Cancelled") {
        cancelled.push(order);
      } else {
        active.push(order);
      }
    }
    return res.status(200).json({ total: orders.length, completed, active, cancelled });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id).populate("orderItems");
    if (!order) {
      return res.status(404).json({ error: "Order not found." });
    }
    return res.status(200).json({ order });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
