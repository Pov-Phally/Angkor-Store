const { Schema, model } = require("mongoose");

const tokenSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  refreshToken: { type: String, required: true },
  accessToken: { type: String },
  createdAt: { type: Date, default: Date.now, expires: "60d" },
});

module.exports = model("Token", tokenSchema);
