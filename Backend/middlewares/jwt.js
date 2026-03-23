const { expressjwt: jwt } = require("express-jwt");
const { Token } = require("../models/token");

function authJwt() {
  const apiUrl = process.env.API_URL;
  return jwt({
    secret: process.env.ACCESS_TOKEN_SECRET,
    algorithms: ["HS256"],
    isRevoked: isRevoked,
  }).unless({
    path: [
      `/${apiUrl}/auth/login`,
      `/${apiUrl}/auth/register`,
      `/${apiUrl}/auth/forgot-password`,
      `/${apiUrl}/auth/verify-otp`,
      `/${apiUrl}/auth/reset-password`,
    ],
  });
}
async function isRevoked(req, jwt) {
  const authHeader = req.headers("Authorization");
  if (!authHeader.startsWith("Bearer ")) {
    return true;
  }
  const accessToken = authHeader.replace("Bearer ", "").trim();
  const token = await Token.findOne({ accessToken });

  const adminRouteRegex = /^\/api\/v1\/admin(\/|$)/;
  const adminFault = !jwt.payload.isAdmin && adminRouteRegex.test(req.originalUrl);

  return adminFault || !token;
}

module.exports = authJwt;
