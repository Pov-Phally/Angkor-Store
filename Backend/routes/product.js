const router = require("express").Router();
const productController = require("../controllers/product");
const reviewController = require("../controllers/review");

router.get("/", productController.getProducts);
router.get("/search", productController.searchProducts);
router.get("/:id", productController.getProductById);
router.post("/:id/reviews", reviewController.leaveReview);
router.get("/:id/reviews", reviewController.getProductReviews);

module.exports = router;
