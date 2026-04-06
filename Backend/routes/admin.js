const router = require("express").Router();
const userController = require("../controllers/admin/user");
const categoryController = require("../controllers/admin/category");
const orderController = require("../controllers/admin/order");

router.get("/users/count", userController.getUsersCount);
router.delete("/users/delete/:id", userController.deleteUser);

//category routes
router.post("/categories/create", categoryController.addCategory);
router.put("/categories/update/:id", categoryController.updateCategory);
router.delete("/categories/delete/:id", categoryController.deleteCategory);

//product routes
// router.get("/products/count", controller.getProductsCount);
// router.post("/products/create", controller.createProduct);
// router.put("/products/update/:id", controller.updateProduct);
// router.delete("/products/delete/:id/images", controller.deleteProductImages);
// router.delete("/products/delete/:id", controller.deleteProduct);

//order routes
router.get("/orders", orderController.getOrders);
router.get("/orders/counts", orderController.getOrdersCounts);
router.put("/orders/update/:id", orderController.updateOrderStatus);
router.delete("/orders/delete/:id", orderController.deleteOrder);

module.exports = router;
