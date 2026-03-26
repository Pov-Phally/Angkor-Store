const router = require("express").Router();
const controller = require("../controllers/admin");

router.get("/users/count", controller.getUsersCount);
router.delete("/users/delete/:id", controller.deleteUser);

//category routes
router.post("/categories/create", controller.createCategory);
router.put("/categories/update/:id", controller.updateCategory);
router.delete("/categories/delete/:id", controller.deleteCategory);

//product routes
router.get("/products/count", controller.getProductsCount);
router.post("/products/create", controller.createProduct);
router.put("/products/update/:id", controller.updateProduct);
router.delete("/products/delete/:id/images", controller.deleteProductImages);
router.delete("/products/delete/:id", controller.deleteProduct);

//order routes
router.get("/orders", controller.getOrders);
router.get("/orders/counts", controller.getOrdersCounts);
router.get("/orders/:id", controller.getOrderById);
router.put("/orders/update/:id", controller.updateOrderStatus);
router.delete("/orders/delete/:id", controller.deleteOrder);

module.exports = router;
