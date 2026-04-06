/**
 * Dummy Order Seed Script
 * Run with: node seed_orders.js
 *
 * Requires existing Users and Products in the DB.
 * Creates OrderItems + Orders referencing them.
 */

const mongoose = require("mongoose");
require("dotenv").config();

const Order = require("./models/order");
const OrderItem = require("./models/order_item");
const User = require("./models/user");
const Product = require("./models/product");

const STATUSES = ["pending", "paid", "shipped", "on-hold", "delivered", "cancelled"];

const ADDRESSES = [
  {
    shippingAddress: "123 Main St",
    city: "Phnom Penh",
    postalCode: "12000",
    country: "Cambodia",
    street: "Monivong Blvd",
  },
  {
    shippingAddress: "456 River Rd",
    city: "Siem Reap",
    postalCode: "17000",
    country: "Cambodia",
    street: "Pub Street",
  },
  {
    shippingAddress: "789 Lake Ave",
    city: "Battambang",
    postalCode: "02000",
    country: "Cambodia",
    street: "Sangker St",
  },
];

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randomPick(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function randomDate(daysBack = 180) {
  const d = new Date();
  d.setDate(d.getDate() - randomInt(0, daysBack));
  return d;
}

async function seed(orderCount = 30) {
  await mongoose.connect(process.env.MONGODB_URI);
  console.log("Connected to MongoDB");

  const users = await User.find().lean();
  const products = await Product.find().lean();

  if (!users.length) {
    console.error("No users found. Seed users first.");
    process.exit(1);
  }
  if (!products.length) {
    console.error("No products found. Seed products first.");
    process.exit(1);
  }

  const createdOrders = [];

  for (let i = 0; i < orderCount; i++) {
    const user = randomPick(users);
    const address = randomPick(ADDRESSES);
    const status = randomPick(STATUSES);
    const itemCount = randomInt(1, 4);

    // Create OrderItems first
    const orderItemIds = [];
    for (let j = 0; j < itemCount; j++) {
      const product = randomPick(products);
      const item = await OrderItem.create({
        productId: product._id,
        productName: product.name,
        productImage: product.image,
        productPrice: product.price,
        quantity: randomInt(1, 5),
        selectSize: randomPick(product.size.length ? product.size : ["M"]),
        selectColor: randomPick(product.color.length ? product.color : ["Black"]),
      });
      orderItemIds.push({ productId: item._id });
    }

    // Create Order referencing those OrderItems
    const order = await Order.create({
      userId: user._id,
      shippingAddress: address.shippingAddress,
      city: address.city,
      postalCode: address.postalCode,
      country: address.country,
      street: address.street,
      phone: `+855 ${randomInt(10, 99)} ${randomInt(100000, 999999)}`,
      paymentId: status !== "pending" ? `PAY-${Date.now()}-${i}` : undefined,
      status,
      statusHistory: { status, date: randomDate() },
      orderItems: orderItemIds,
      orderDate: randomDate(),
    });

    createdOrders.push(order._id);
    console.log(
      `[${i + 1}/${orderCount}] Created order ${order._id} | status: ${status} | items: ${itemCount}`,
    );
  }

  console.log(`\nDone! Created ${createdOrders.length} orders.`);
  await mongoose.disconnect();
}

seed(30).catch((err) => {
  console.error(err);
  process.exit(1);
});
