const { validationResult } = require("express-validator");
const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Token = require("../models/token");
const { sendEmail } = require("../helpers/email_sender");

exports.Register = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      errors: errors.array().map((err) => ({
        field: err.path,
        message: err.msg,
      })),
    });
  }
  try {
    let user = new User({
      ...req.body,
      passwordHash: bcrypt.hashSync(req.body.password, 8),
    });
    user = await user.save();
    if (!user) {
      return res.status(400).json({ error: "User cannot be created" });
    }
    return res.status(201).json({ message: "User created successfully", user });
  } catch (error) {
    if (error.message.includes("duplicate key error")) {
      return res.status(409).json({ error: "Email already exists" });
    }
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.Login = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      errors: errors.array().map((err) => ({
        field: err.path,
        message: err.msg,
      })),
    });
  }
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: "email does not exist" });
    }
    const isPasswordValid = bcrypt.compareSync(password, user.passwordHash);
    if (!isPasswordValid) {
      return res.status(401).json({ error: "incorrect password" });
    }
    const accessToken = jwt.sign(
      { userId: user._id, isAdmin: user.isAdmin },
      process.env.ACCESS_TOKEN_SECRET,
      {
        expiresIn: "1h",
      },
    );
    const refreshToken = jwt.sign(
      { userId: user._id, isAdmin: user.isAdmin },
      process.env.REFRESH_TOKEN_SECRET,
      {
        expiresIn: "60d",
      },
    );
    const token = await Token.findOne({ userId: user._id });
    if (token) await token.deleteOne();
    await new Token({ userId: user._id, accessToken, refreshToken }).save();

    return res.status(200).json({
      message: "Login successful",
      user: { ...user._doc, passwordHash: undefined },
      accessToken,
      refreshToken,
    });
  } catch (error) {
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.VerifyToken = async (req, res) => {
  try {
    // Get the access token from the request header
    let accessToken = req.headers.authorization;
    if (!accessToken) return res.json(false);
    accessToken = accessToken.replace("Bearer ", "").trim();
    // Check if the access token exists in the database
    const token = await Token.findOne({ accessToken });
    if (!token) return res.json(false);
    // Decode the refresh token to get the user ID
    const tokenData = jwt.decode(token.refreshToken);
    // Check if the user exists in the database
    const user = await User.findById(tokenData._id);
    if (!user) return res.json(false);
    // Verify the refresh token
    const isValid = jwt.verify(token.refreshToken, process.env.REFRESH_TOKEN_SECRET);
    if (!isValid) return res.json(false);

    return res.json(true);
  } catch (error) {
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.ForgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: "email does not exist" });
    }
    // Generate a 6-digit OTP and set it in the user's document with an expiration time
    const otp = Math.floor(100000 + Math.random() * 900000);
    user.resetPasswordOtp = otp;
    user.resetPasswordExpires = Date.now() + 10 * 60 * 1000; // OTP expires in 10 minutes
    await user.save();
    // Send the OTP to the user's email
    let response;
    try {
      response = await sendEmail(
        email,
        "Password Reset OTP",
        `Your OTP for password reset is: ${otp}`,
      );
    } catch (mailError) {
      return res.status(500).json({ error: "Failed to send OTP email" });
    }

    // sendEmail may return undefined/null on success
    if (response?.error) {
      return res.status(500).json({ error: "Failed to send OTP email" });
    }

    return res.status(200).json({ message: "OTP sent successfully" });
  } catch (error) {
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.VerifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: "email does not exist" });
    }
    if (user.resetPasswordOtp !== +otp || user.resetPasswordExpires < Date.now()) {
      return res.status(400).json({ error: "Invalid or expired OTP" });
    }
    user.resetPasswordOtp = 1;
    user.resetPasswordExpires = undefined;
    await user.save();
    return res.status(200).json({ message: "OTP verified successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.ResetPassword = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      errors: errors.array().map((err) => ({
        field: err.path,
        message: err.msg,
      })),
    });
  }
  try {
    const { email, newPassword } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: "email does not exist" });
    }
    if (user.resetPasswordOtp !== 1) {
      return res.status(400).json({ error: "OTP verification required" });
    }
    user.passwordHash = bcrypt.hashSync(newPassword, 8);
    user.resetPasswordOtp = undefined;
    await user.save();
    return res.status(200).json({ message: "Password reset successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.Logout = async (req, res) => {};
