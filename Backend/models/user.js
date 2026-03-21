const { Schema, model } = require("mongoose");

const userSchema = new Schema({
  name: { type: String, required: true, trim: true },
  email: { type: String, required: true, trim: true, unique: true },
  passwordHash: { type: String, required: true },
  country: { type: String, trim: true },
  city: { type: String, trim: true },
  street: { type: String, trim: true },
  postalCode: { type: String, trim: true },
  phone: { type: String, required: true, trim: true },
  isAdmin: { type: Boolean, default: false },
  resetPasswordOtp: { type: Number },
  resetPasswordExpires: { type: Date },
  whishlist: [
    {
      productId: {
        type: Schema.Types.ObjectId,
        ref: "Product",
        required: true,
      },
      productName: { type: String, required: true, trim: true },
      productImage: { type: String, required: true, trim: true },
      productPrice: { type: Number, required: true },
    },
  ],
});

exports.User = model("User", userSchema);
