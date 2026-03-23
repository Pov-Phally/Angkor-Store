const jwt = require("jsonwebtoken");
const { Token } = require("../models/token");

async function errorHandler(err, req, res, next) {
  if (err.name === "UnauthorizedError") {
    if (!err.message.includes("jwt expired")) {
      return res.status(err.status).json({ type: err.name, message: err.message });
    }

    try {
      const authHeader = req.headers("Authorization");
      const accessToken = authHeader.replace("Bearer ", "").trim();
      const token = await Token.findOne({ accessToken, refreshToken: { $exists: true } });

      if (!token) {
        return res.status(401).json({ type: "Unauthorized", message: "Invalid token" });
      }
      const userData = jwt.verify(token.refreshToken, process.env.REFRESH_TOKEN_SECRET);
      const user = await User.findById(userData.id);
      if (!user) {
        return res.status(401).json({ type: "Unauthorized", message: "User not found" });
      }
      const newAccessToken = jwt.sign({ id: user.id, isAdmin: user.isAdmin }, process.env.ACCESS_TOKEN_SECRET, {
        expiresIn: "24h",
      });
      req.headers["Authorization"] = `Bearer ${newAccessToken}`;
      token.accessToken = newAccessToken;
      await token.save();
      res.set("Authorization", `Bearer ${newAccessToken}`);
      return next();
    } catch (error) {
      return res.status(401).json({ type: "Unauthorized", message: error.message });
    }
  }
  return res.status(500).json({ type: err.name, message: err.message });
}
module.exports = errorHandler;
