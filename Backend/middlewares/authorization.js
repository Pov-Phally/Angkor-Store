const jwt = require("jsonwebtoken");
const { default: mongoose } = require("mongoose");
async function authorizePostRequests(req, res, next) {
  API_URL = process.env.API_URL;
  if (req.method !== "POST") return next();
  if (req.originalUrl.startsWith(`${API_URL}/admin`)) return next();
  const endPoints = [
    `/${API_URL}/auth/login`,
    `/${API_URL}/auth/register`,
    `/${API_URL}/auth/forgot-password`,
    `/${API_URL}/auth/verify-otp`,
    `/${API_URL}/auth/reset-password`,
  ];
  const isMatchingEndPoint = endPoints.some((endPoint) => req.originalUrl.includes(endPoint));

  if (isMatchingEndPoint) return next();

  const authHeader = req.headers["authorization"];
  if (!authHeader) return next();
  const accessToken = authHeader.replace("Bearer ", "").trim();
  const tokenData = jwt.decode(accessToken);

  if (req.body.user && tokenData.id !== req.body.user) {
    return res.status(403).json({ message: "Forbidden: User ID does not match token" });
  } else if (/\/users\/([^/]+)\//.test(req.originalUrl)) {
    const parts = req.originalUrl.split("/");
    const userIndex = parts.indexOf("users");
    const id = parts[userIndex + 1];
    if (!mongoose.isValidObjectId(id)) return next();
    if (tokenData.id !== id) {
      return res.status(403).json({ message: "Forbidden: User ID in URL does not match token" });
    }
  }
  return next();
}
module.exports = authorizePostRequests;
