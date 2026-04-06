const Order = require("../../models/order");
const OrderItem = require("../../models/order_item");

exports.getOrders = async (_, res) => {
  try {
    const orders = await Order.find()
      .select("-statusHistory")
      .populate("userId", "name email")
      .sort({ orderDate: -1 })
      .populate({
        path: "orderItems",
        populate: {
          path: "productId",
          select: "productName productImage productPrice",
        },
      });
    if (!orders || orders.length === 0) {
      return res.status(404).json({ error: "No orders found." });
    }
    return res.status(200).json({ orders });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getOrdersCounts = async (_, res) => {
  try {
    const ordersCount = await Order.countDocuments();
    if (ordersCount === 0) {
      return res.status(404).json({ error: "No orders found." });
    }
    return res.status(200).json({ ordersCount });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  const orderId = req.params.id;
  const { status } = req.body;
  try {
    let order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({ error: "Order not found." });
    }
    // Check if current status is already in history, if not add it
    const statusExists = order.statusHistory.some((history) => history.status === order.status);
    if (!statusExists) {
      order.statusHistory.push({ status: order.status, date: new Date() });
    }
    order.status = status;
    await order.save();
    return res.status(200).json({ message: `Order ${orderId} status updated to ${status}` });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.deleteOrder = async (req, res) => {
  const orderId = req.params.id;
  try {
    const order = await Order.findByIdAndDelete(orderId);
    if (!order) {
      return res.status(404).json({ error: "Order not found." });
    }
    for (const orderItemIds of order.orderItems) {
      await OrderItem.findByIdAndDelete(orderItemIds.productId);
    }
    return res.status(200).json({ message: `Order ${orderId} deleted successfully.` });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
