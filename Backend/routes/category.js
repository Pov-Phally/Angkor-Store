const router = require("express").Router();
const controller = require("../controllers/category");

router.get("/", controller.getCategories);
router.get("/:id", controller.getCategoryById);

module.exports = router;
