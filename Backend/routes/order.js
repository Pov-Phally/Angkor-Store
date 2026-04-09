const router = require("express").Router();
const controller = require("../controllers/order");

router.post("/users/:userId", controller.getUserOrders);
router.post("/:id", controller.getOrderById);

module.exports = router;
