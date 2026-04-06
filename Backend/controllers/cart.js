const User = require("../models/user");
const cartProduct = require("../models/cart_product");
const Product = require("../models/product");
exports.getCart = async (req, res) => {
  const userId = req.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    const cartProducts = await cartProduct.find({ _id: { $in: user.cart } });
    if (!cartProducts) {
      return res.status(404).json({ error: "Cart products not found" });
    }
    const cart = [];
    for (const cartProduct of cartProducts) {
      const product = await Product.findById(cartProduct.productId);
      if (!product) {
        cart.push({ ...cartProduct._doc, productExists: false, productOutOfStock: false });
      } else {
        cartProduct.productName = product.name;
        cartProduct.productImage = product.image;
        cartProduct.productPrice = product.price;
        if (product.countInStock < cartProduct.quantity) {
          cart.push({ ...cartProduct._doc, productExists: true, productOutOfStock: true });
        } else {
          cart.push({ ...cartProduct._doc, productExists: true, productOutOfStock: false });
        }
      }
    }
    return res.status(200).json(cart);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getCartCount = async (req, res) => {};

exports.getCartProductById = async (req, res) => {};

exports.addToCart = async (req, res) => {};

exports.updateCartProductQuantity = async (req, res) => {};

exports.removeFromCart = async (req, res) => {};
