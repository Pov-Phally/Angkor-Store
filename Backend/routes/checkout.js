const controller = require("../controllers/checkout");
const express = require("express");
const router = express.Router();

router.post("/", controller.checkOut);
router.post("/webhook", express.raw({ type: "application/json" }), controller.webHook);
module.exports = router;
