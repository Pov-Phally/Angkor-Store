const router = require("express").Router();
const controller = require("../controllers/auth");
const validator = require("../validator/user_validator");

router.post("/register", validator.validateRegistration, controller.Register);

router.post("/login", validator.validateLogin, controller.Login);

router.post("/verify-token", controller.VerifyToken);

router.post("/forgot-password", validator.validateForgotPassword, controller.ForgotPassword);

router.post("/verify-otp", controller.VerifyOtp);

router.post("/reset-password", validator.validateResetPassword, controller.ResetPassword);

router.post("/logout", controller.Logout);

module.exports = router;
