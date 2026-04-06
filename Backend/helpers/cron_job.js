const cron = require("node-cron");
const Category = require("../models/category");
const Product = require("../models/product");
//
cron.schedule("0 0 * * *", async () => {
  try {
    const categoryMarkForDeletion = await Category.find({ markForDeletion: true });
    console.log(`\n[CRON] Found ${categoryMarkForDeletion.length} categories marked for deletion`);

    for (const category of categoryMarkForDeletion) {
      console.log(`\n[CRON] Checking category: ${category._id} - "${category.name}"`);

      try {
        // Delete all products in this category
        const productInCategory = await Product.deleteMany({ category: category._id });
        console.log(`[CRON] Deleted ${productInCategory.deletedCount} products from category`);

        // Delete the category
        const deletedCategory = await Category.findByIdAndDelete(category._id);
        console.log(`[CRON] ✓ Successfully deleted category "${category.name}"`);
      } catch (deleteErr) {
        console.error(`[CRON] ✗ Failed to delete category "${category.name}":`, deleteErr.message);
      }
    }

    console.log(`\n[CRON] Job executed at ${new Date().toLocaleString()}\n`);
  } catch (error) {
    console.error("[CRON] Error running cron job:", error);
  }
});
