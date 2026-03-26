const { Schmema, model } = require("mongoose");
const product = require("./product");

const CartProductSchema = new Schmema({
  productId: { type: Schema.Types.ObjectId, ref: "Product", required: true },
  productName: { type: String, required: true, trim: true },
  productImage: { type: String, required: true, trim: true },
  productPrice: { type: Number, required: true },
  quantity: { type: Number, required: true, min: 1 },
  selectSize: { type: String, required: true, trim: true },
  selectColor: { type: String, required: true, trim: true },
  reservationExpiry: { type: Date, default: Date.now() + 30 * 60 * 1000 },
  reserved: { type: Boolean, default: true },
});

CartProductSchema.set("toJSON", { virtuals: true });
CartProductSchema.set("toObject", { virtuals: true });

module.exports = model("CartProduct", CartProductSchema);
