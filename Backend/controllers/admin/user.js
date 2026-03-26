const User = require("../../models/user");
const Order = require("../../models/order");
const OrderItem = require("../../models/order_item");
const CardProduct = require("../../models/cart_product");
const Token = require("../../models/token");

exports.getUsersCount = async (_, res) => {
  try {
    const usersCount = await User.countDocuments();
    if (!usersCount) {
      return res
        .status(404)
        .json({ error: "Not Found", message: "No users found" });
    }
    return res.status(200).json({ usersCount });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.deleteUser = async (req, res) => {
  try {
    const userId = req.params.id;
    const user = await User.findById(userId);
    if (!user) {
      return res
        .status(404)
        .json({ error: "Not Found", message: "User not found" });
    }
    const orders = await Order.find({ userId: userId });
    const orderItemIds = orders.flatMap((order) => order.orderItems);

    await Order.deleteMany({ userId: userId });
    await OrderItem.deleteMany({ _id: { $in: orderItemIds } });
    await CardProduct.deleteMany({ _id: { $in: user.cart } });
    await User.findByIdAndUpdate(userId, {
      $pull: { cart: { $exists: true } },
    });

    await Token.deleteOne({ userId: userId });
    await User.deleteOne({ _id: userId });

    return res
      .status(204)
      .json({ message: "User and associated data deleted successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
