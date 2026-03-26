const { Schema, model } = require("mongoose");

const productSchema = new Schema({
  name: { type: String, required: true, trim: true },
  description: { type: String, required: true, trim: true },
  price: { type: Number, required: true, min: 0 },
  rating: { type: Number, default: 0, min: 0, max: 5 },
  color: [{ type: String, trim: true }],
  size: [{ type: String, required: true, trim: true }],
  image: { type: String, required: true, trim: true },
  images: [{ type: String, trim: true }],
  reviews: [{ type: Schema.Types.ObjectId, ref: "Review" }],
  numberOfReviews: { type: Number, default: 0 },
  category: { type: Schema.Types.ObjectId, ref: "Category", required: true },
  genderAgeCategory: { type: String, enum: ["men", "women", "kids", "unisex"], required: true },
  countInStock: { type: Number, required: true, min: 0, max: 255 },
  dateAdded: { type: Date, default: Date.now },
});

productSchema.pre("save", async function (next) {
  if (this.reviews.length > 0) {
    await this.populate("reviews");
    const totalRating = this.reviews.reduce((sum, review) => sum + review.rating, 0);
    this.rating = totalRating / this.reviews.length;
    this.rating = parseFloat((totalRating / this.reviews.length).toFixed(1));
    this.numberOfReviews = this.reviews.length;
  }
  next();
});

productSchema.index({ name: "text", description: "text" });

productSchema.set("toJSON", { virtuals: true });
productSchema.set("toObject", { virtuals: true });

module.exports = model("Product", productSchema);
