const { Schema, model } = require("mongoose");

const categorySchema = new Schema({
  name: { type: String, required: true, trim: true, unique: true },
  color: { type: String, default: "#000000" },
  image: { type: String, required: true },
  markForDeletion: { type: Boolean, default: false },
});
categorySchema.set("toJSON", { virtuals: true });
categorySchema.set("toObject", { virtuals: true });

module.exports = model("Category", categorySchema);
