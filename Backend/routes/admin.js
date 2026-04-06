const router = require("express").Router();
const userController = require("../controllers/admin/user");
const categoryController = require("../controllers/admin/category");
const orderController = require("../controllers/admin/order");
const productController = require("../controllers/admin/product");

router.get("/users/count", userController.getUsersCount);
router.delete("/users/delete/:id", userController.deleteUser);

//category routes
router.post("/categories/create", categoryController.createCategory);
router.put("/categories/update/:id", categoryController.updateCategory);
router.delete("/categories/delete/:id", categoryController.deleteCategory);

//product routes
router.get("/products/count", productController.getProductsCount);
router.get("/products", productController.getProducts);
router.post("/products/create", productController.createProduct);
router.put("/products/update/:id", productController.updateProduct);
router.delete("/products/delete/:id/images", productController.deleteProductImages);
router.delete("/products/delete/:id", productController.deleteProduct);

//order routes
router.get("/orders", orderController.getOrders);
router.get("/orders/counts", orderController.getOrdersCounts);
router.put("/orders/update/:id", orderController.updateOrderStatus);
router.delete("/orders/delete/:id", orderController.deleteOrder);

module.exports = router;
