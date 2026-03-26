const { Schema, model, Types } = require("mongoose");

const orderSchema = new Schema({
  userId: { type: Types.ObjectId, ref: "User", required: true },
  shippingAddress: { type: String, required: true, trim: true },
  city: { type: String, required: true, trim: true },
  postalCode: { type: String, required: true, trim: true },
  country: { type: String, required: true, trim: true },
  street: { type: String, required: true, trim: true },
  phone: { type: String, required: true, trim: true },
  paymentId: { type: String },
  status: {
    type: String,
    enum: ["pending", "paid", "shipped", "on-hold", "delivered", "cancelled"],
    required: true,
    default: "pending",
  },
  statusHistory: {
    status: {
      type: String,
      enum: ["pending", "paid", "shipped", "on-hold", "delivered", "cancelled"],
      required: true,
      default: "pending",
    },
    date: { type: Date, default: Date.now },
  },
  orderDate: { type: Date, default: Date.now },
  orderItems: [
    {
      productId: { type: Types.ObjectId, ref: "OrderItem", required: true },
    },
  ],
});
orderSchema.set("toJSON", { virtuals: true });
orderSchema.set("toObject", { virtuals: true });

module.exports = model("Order", orderSchema);
