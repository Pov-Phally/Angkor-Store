const User = require("../models/user");
const Product = require("../models/product");
const { default: mongoose } = require("mongoose");
exports.getWishlist = async (req, res) => {
  const userId = req.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const wishlist = [];
    for (const wishlistProduct of user.wishlist) {
      const product = await Product.findById(wishlistProduct.productId);
      if (!product) {
        wishlist.push({ ...wishlistProduct, productExists: false, productOutOfStock: false });
      } else {
        if (product.countInStock < 1) {
          wishlist.push({ ...wishlistProduct, productExists: true, productOutOfStock: true });
        } else {
          wishlist.push({
            productId: product._id,
            productName: product.name,
            productImage: product.image,
            productPrice: product.price,
            productExists: true,
            productOutOfStock: false,
          });
        }
      }
    }
    return res.status(200).json(wishlist);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Error fetching wishlist" });
  }
};

exports.addToWishlist = async (req, res) => {
  const userId = req.params.id;
  const productId = req.body.productId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }
    const productAlreadyInWishlist = user.wishlist.find((item) =>
      item.productId.equals(new mongoose.Schema.Types.ObjectId(productId)),
    );
    if (productAlreadyInWishlist) {
      return res.status(409).json({ message: "Product already in wishlist" });
    }
    user.wishlist.push({
      productId: productId,
      productName: product.name,
      productImage: product.image,
      productPrice: product.price,
    });
    await user.save();
    return res.status(200).json({ message: "Product added to wishlist" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Error adding to wishlist" });
  }
};

exports.removeFromWishlist = async (req, res) => {
  const userId = req.params.id;
  const productId = req.params.productId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const index = user.wishlist.findIndex((item) =>
      item.productId.equals(new mongoose.Schema.Types.ObjectId(productId)),
    );
    if (index === -1) {
      return res.status(404).json({ message: "Product not found in wishlist" });
    }
    user.wishlist.splice(index, 1);
    await user.save();
    return res.status(204).json({ message: "Product removed from wishlist" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Error removing from wishlist" });
  }
};
