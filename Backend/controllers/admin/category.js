const mediaHelper = require("../../helpers/media_helper");
const util = require("util");
const Category = require("../../models/category");

exports.createCategory = async (req, res) => {
  try {
    const uploadImage = util.promisify(mediaHelper.upload.fields([{ name: "image", maxCount: 1 }]));

    try {
      await uploadImage(req, res);
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        error: error.code,
        message: `${error.message}{${error.fields}}`,
        storageError: error.storageErrors,
      });
    }
    const image = req.files["image"][0];
    if (!image) {
      return res.status(400).json({ error: "No image file uploaded." });
    }
    req.body["image"] = `${req.protocol}://${req.get("host")}/uploads/${image.path}`;
    let category = new Category(req.body);
    await category.save();
    if (!category) {
      return res.status(400).json({ error: "Failed to create category." });
    }
    return res.status(201).json({
      message: `Category ${category.name} created successfully`,
      category,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.updateCategory = async (req, res) => {
  const categoryId = req.params.id;
  const { name, icon, color } = req.body;
  try {
    const category = await Category.findByIdAndUpdate(
      categoryId,
      { name, icon, color },
      { new: true },
    );
    if (!category) {
      return res.status(404).json({ error: "Category not found." });
    }
    return res.status(200).json({
      message: `Category ${category.name} updated successfully`,
      category,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.deleteCategory = async (req, res) => {
  const categoryId = req.params.id;
  try {
    const category = await Category.findById(categoryId);
    if (!category) {
      return res.status(404).json({ error: "Category not found." });
    }
    category.markForDeletion = true;
    await category.save();
    return res.status(200).json({ message: `Category ${category.name} deleted successfully` });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
