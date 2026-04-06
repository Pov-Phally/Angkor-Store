const router = require("express").Router();
const controller = require("../controllers/users");
const cartController = require("../controllers/cart");
const wishlistController = require("../controllers/wishlist");

router.get("/", controller.getUsers);
router.get("/:id", controller.getUserById);
router.put("/update/:id", controller.updateUser);
router.delete("/delete/:id", controller.deleteUser);

//whistlist routes
router.get("/:id/wishlist", wishlistController.getWishlist);
router.post("/:id/wishlist/add/:productId", wishlistController.addToWishlist);
router.delete("/:id/wishlist/remove/:productId", wishlistController.removeFromWishlist);

//cart routes
router.get("/:id/cart", cartController.getCart);
router.get("/:id/cart/count", cartController.getCartCount);
router.get("/:id/cart/:productId", cartController.getCartProductById);
router.post("/:id/cart/add/:productId", cartController.addToCart);
router.put("/:id/cart/update/:productId", cartController.updateCartProductQuantity);
router.delete("/:id/cart/remove/:productId", cartController.removeFromCart);

module.exports = router;
