const User = require("../models/User");
const Product = require("../models/product");
const Review = require("../models/review");
exports.leaveReview = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ error: error.name, message: "User not found" });
    }
    const review = new Review({
      ...req.body,
      userName: user.name,
    }).save();
    if (!review) {
      return res.status(400).json({ error: error.name, message: "Failed to save review" });
    }
    let product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ error: error.name, message: "Product not found" });
    }
    product.reviews.push(review._id);
    product = await product.save();
    if (!product) {
      return res
        .status(400)
        .json({ error: error.name, message: "Failed to update product with review" });
    }
    return res.status(201).json({ product, review });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getProductReviews = async (req, res) => {
  try {
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
