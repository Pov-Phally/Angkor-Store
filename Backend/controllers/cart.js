const User = require("../models/user");
const cartProduct = require("../models/cart_product");
const Product = require("../models/product");
const { mongo } = require("mongoose");

exports.getCart = async (req, res) => {
  const userId = req.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    const cartProducts = await cartProduct.find({ _id: { $in: user.cart } });
    if (!cartProducts) {
      return res.status(404).json({ error: "Cart products not found" });
    }
    const cart = [];
    for (const cartProduct of cartProducts) {
      const product = await Product.findById(cartProduct.productId);
      if (!product) {
        cart.push({
          ...cartProduct._doc,
          productExists: false,
          productOutOfStock: false,
        });
      } else {
        cartProduct.productName = product.name;
        cartProduct.productImage = product.image;
        cartProduct.productPrice = product.price;
        if (product.countInStock < cartProduct.quantity) {
          cart.push({
            ...cartProduct._doc,
            productExists: true,
            productOutOfStock: true,
          });
        } else {
          cart.push({
            ...cartProduct._doc,
            productExists: true,
            productOutOfStock: false,
          });
        }
      }
    }
    return res.status(200).json(cart);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getCartCount = async (req, res) => {
  const userId = req.params.id;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    const cartCount = user.cart.length;
    return res.status(200).json({ cartCount });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getCartProductById = async (req, res) => {
  const cartProductId = req.params.id;
  try {
    const cartProduct = await cartProduct.findById(cartProductId);
    if (!cartProduct) {
      return res.status(404).json({ error: "Cart product not found" });
    }
    const product = await Product.findById(cartProduct.productId);
    if (!product) {
      cart.push({
        ...cartProduct._doc,
        productExists: false,
        productOutOfStock: false,
      });
    } else {
      cartProduct.productName = product.name;
      cartProduct.productImage = product.image;
      cartProduct.productPrice = product.price;
      if (product.countInStock < cartProduct.quantity) {
        cart.push({
          ...cartProduct._doc,
          productExists: true,
          productOutOfStock: true,
        });
      } else {
        cart.push({
          ...cartProduct._doc,
          productExists: true,
          productOutOfStock: false,
        });
      }
    }
    return res.status(200).json(cartProduct);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.addToCart = async (req, res) => {
  const session = await mongoose.startSession();
  session.startTransaction();
  const userId = req.params.id;
  try {
    const { productId } = req.body;
    const user = await User.findById(userId);
    if (!user) {
      await session.abortTransaction();
      return res.status(404).json({ error: "User not found" });
    }
    const userCartProducts = await cartProduct.find({
      _id: { $in: user.cart },
    });
    const existingCartProduct = userCartProducts.find(
      (item) =>
        item.productId.equals(mongo.Types.ObjectId(productId)) &&
        item.selectSize === req.body.selectSize &&
        item.selectColor === req.body.selectColor,
    );
    const product = await Product.findById(productId).session(session);
    if (!product) {
      await session.abortTransaction();
      return res.status(404).json({ error: "Product not found" });
    }
    if (existingCartProduct) {
      let condition = product.countInStock >= existingCartProduct.quantity + 1;
      if (existingCartProduct.reserved) {
        condition = product.countInStock >= 1;
      }
      if (condition) {
        existingCartProduct.quantity += 1;
        await existingCartProduct.save({ session });
        await Product.findByIdAndUpdate(productId, {
          $inc: { countInStock: -1 },
        }).session(session);
        await session.commitTransaction();
        return res.status(200).json(existingCartProduct);
      }
      await session.abortTransaction();
      return res.status(400).json({ error: "Product is out of stock" });
    }
    const { quantity, selectSize, selectColor } = req.body;
    const newCartProduct = new cartProduct({
      quantity,
      selectSize,
      selectColor,
      productId,
      productName: product.name,
      productImage: product.image,
      productPrice: product.price,
    }).save({ session });
    if (!newCartProduct) {
      await session.abortTransaction();
      return res.status(500).json({ error: "Failed to add product to cart" });
    }
    user.cart.push(newCartProduct._id);
    await user.save({ session });
    const updatedProduct = await Product.findByIdAndUpdate(
      { _id: productId, countInStock: { $gte: quantity } },
      { $inc: { countInStock: -cartProduct.quantity } },
      { new: true, session },
    );
    if (!updatedProduct) {
      await session.abortTransaction();
      return res.status(400).json({ error: "Product is out of stock" });
    }
    await session.commitTransaction();
    return res.status(200).json(newCartProduct);
  } catch (error) {
    await session.abortTransaction();
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};

exports.updateCartProductQuantity = async (req, res) => {
  const userId = req.params.id;
  const cartProductId = req.params.cartProductId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    const { quantity } = req.body;
    let cartProduct = await cartProduct.findById(cartProductId);
    if (!cartProduct) {
      return res.status(404).json({ error: "Cart product not found" });
    }
    const product = await Product.findById(cartProduct.productId);
    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }
    if (quantity > cartProduct.countInStock) {
      return res.status(400).json({ error: "Product is out of stock" });
    }
    cartProduct = await cartProduct.findByIdAndUpdate(
      cartProductId,
      { quantity },
      { new: true },
    );
    if (!cartProduct) {
      return res
        .status(500)
        .json({ error: "Failed to update cart product quantity" });
    }
    return res.status(200).json(cartProduct);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.removeFromCart = async (req, res) => {
  const session = await mongoose.startSession();
  session.startTransaction();
  const userId = req.params.id;
  const cartProductId = req.params.cartProductId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      await session.abortTransaction();
      return res.status(404).json({ error: "User not found" });
    }
    if (!user.cart.includes(cartProductId)) {
      await session.abortTransaction();
      return res
        .status(404)
        .json({ error: "Cart product not found in user's cart" });
    }
    const removedCartProduct = await cartProduct
      .findById(cartProductId)
      .session(session);
    if (!removedCartProduct) {
      await session.abortTransaction();
      return res.status(404).json({ error: "Cart product not found" });
    }
    if (removedCartProduct.reserved) {
      const updatedProduct = await Product.findByIdAndUpdate(
        removedCartProduct.productId,
        { $inc: { countInStock: removedCartProduct.quantity } },
        { new: true, session },
      );
      if (!updatedProduct) {
        await session.abortTransaction();
        return res.status(404).json({ error: "Product not found" });
      }
    }
    user.cart.pull(removedCartProduct._id);
    await user.save({ session });
    await cartProduct
      .findByIdAndDelete(removedCartProduct._id)
      .session(session);
    await session.commitTransaction();
    return res
      .status(200)
      .json({ message: "Cart product removed successfully" });
  } catch (error) {
    console.error(error);
    await session.abortTransaction();
    return res.status(500).json({ error: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
};
