const cron = require("node-cron");
const Category = require("../models/category");
const Product = require("../models/product");
const cartProduct = require("../models/cart_product");
const mongoose = require("mongoose");
//
cron.schedule("0 0 * * *", async () => {
  try {
    const categoryMarkForDeletion = await Category.find({
      markForDeletion: true,
    });
    console.log(
      `\n[CRON] Found ${categoryMarkForDeletion.length} categories marked for deletion`,
    );

    for (const category of categoryMarkForDeletion) {
      console.log(
        `\n[CRON] Checking category: ${category._id} - "${category.name}"`,
      );

      try {
        // Delete all products in this category
        const productInCategory = await Product.deleteMany({
          category: category._id,
        });
        console.log(
          `[CRON] Deleted ${productInCategory.deletedCount} products from category`,
        );

        // Delete the category
        const deletedCategory = await Category.findByIdAndDelete(category._id);
        console.log(
          `[CRON] ✓ Successfully deleted category "${category.name}"`,
        );
      } catch (deleteErr) {
        console.error(
          `[CRON] ✗ Failed to delete category "${category.name}":`,
          deleteErr.message,
        );
      }
    }

    console.log(`\n[CRON] Job executed at ${new Date().toLocaleString()}\n`);
  } catch (error) {
    console.error("[CRON] Error running cron job:", error);
  }
});

cron.schedule("*/30 * * * *", async () => {
  const session = await mongoose.startSession();
  session.startTransaction();
  try {
    console.log(
      `\n[CRON] Running reservation cleanup at ${new Date().toLocaleString()}`,
    );
    const expiredCartProducts = await cartProduct
      .find({
        reserved: true,
        reservationExpiresAt: { $lte: new Date() },
      })
      .session(session);
    for (const cartProduct of expiredCartProducts) {
      console.log(
        `[CRON] Processing expired reservation for cart product ID: ${cartProduct._id}`,
      );
      const product = await Product.findById(cartProduct.productId).session(
        session,
      );
      if (product) {
        const updateProduct = await Product.findByIdAndUpdate(
          product._id,
          { $inc: { countInStock: cartProduct.quantity } },
          { new: true, runValidators: true, session },
        );
        if (!updateProduct) {
          console.error(`[CRON] ✗ Failed to update product "${product.name}"`);
          await session.abortTransaction();
          return;
        }
      }

      await cartProduct.findByIdAndUpdate(
        cartProduct._id,
        { reserved: false, reservationExpiresAt: null },
        { new: true, session },
      );
      console.log(
        `[CRON] ✓ Released reservation for product "${product.name}", updated stock to ${updateProduct.countInStock}`,
      );
    }
    session.commitTransaction();
    console.log(
      `[CRON] Reservation cleanup completed at ${new Date().toLocaleString()}\n`,
    );
  } catch (error) {
    console.error("[CRON] Error running cron job:", error);
    await session.abortTransaction();
    return res.status(500).json({ error: error.name, message: error.message });
  } finally {
    await session.endSession();
  }
});
