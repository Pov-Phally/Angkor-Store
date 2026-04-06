const User = require("../models/user");
const Product = require("../models/product");
const Review = require("../models/review");
const { default: mongoose } = require("mongoose");
exports.leaveReview = async (req, res) => {
  try {
    const user = await User.findById(req.body.userId);
    if (!user) {
      return res.status(404).json({ error: "UserNotFound", message: "User not found" });
    }
    const review = await new Review({
      ...req.body,
      userName: user.name,
    }).save();
    if (!review) {
      return res.status(400).json({ error: "ReviewSaveFailed", message: "Failed to save review" });
    }
    let product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ error: "ProductNotFound", message: "Product not found" });
    }
    product.reviews.push(review._id);
    product = await product.save();
    if (!product) {
      return res
        .status(400)
        .json({ error: "ProductUpdateFailed", message: "Failed to update product with review" });
    }
    return res.status(201).json({ product, review });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getProductReviews = async (req, res) => {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    const product = await Product.findById(req.params.id);
    if (!product) {
      await session.abortTransaction();
      return res.status(404).json({ error: "Product Not Found", message: "Product not found" });
    }
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const reviews = await Review.find({ _id: { $in: product.reviews } })
      .sort({ date: -1 })
      .skip(skip)
      .limit(limit);

    const processReviews = [];
    for (const review of reviews) {
      const user = await User.findById(review.userId);
      if (!user) {
        processReviews.push({ review });
        continue;
      }
      let newReview;
      if (review.userName !== user.name) {
        review.userName = user.name;
        newReview = await review.save({ session });
      }
      processReviews.push(newReview ?? review);
    }
    await session.commitTransaction();
    return res.status(200).json({ reviews: processReviews });
  } catch (error) {
    await session.abortTransaction();
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};
