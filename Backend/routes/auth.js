const router = require("express").Router();
const Controller = require("../controllers/auth");
const validator = require("../validator/user_validator");

router.post("/register", validator.validateRegistration, Controller.Register);

router.post("/login", validator.validateLogin, Controller.Login);

router.post("/verify-token", Controller.VerifyToken);

router.post("/forgot-password", validator.validateForgotPassword, Controller.ForgotPassword);

router.post("/verify-otp", Controller.VerifyOtp);

router.post("/reset-password", validator.validateResetPassword, Controller.ResetPassword);

router.post("/logout", Controller.Logout);

module.exports = router;
