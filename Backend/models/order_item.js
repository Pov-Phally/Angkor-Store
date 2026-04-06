const { Schema, model } = require("mongoose");
const product = require("./product");

const OrderItemSchema = new Schema({
  productId: { type: Schema.Types.ObjectId, ref: "Product", required: true },
  productName: { type: String, required: true, trim: true },
  productImage: { type: String, required: true, trim: true },
  productPrice: { type: Number, required: true },
  quantity: { type: Number, required: true, min: 1 },
  selectSize: { type: String, required: true, trim: true },
  selectColor: { type: String, required: true, trim: true },
});
OrderItemSchema.set("toJSON", { virtuals: true });
OrderItemSchema.set("toObject", { virtuals: true });

module.exports = model("OrderItem", OrderItemSchema);
