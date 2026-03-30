const Product = require("../../models/product");
const mediaHelper = require("../../helpers/media_helper");
const util = require("util");
const Category = require("../../models/category");
const multer = require("multer");
const Review = require("../../models/review");

exports.getProductsCount = async (req, res) => {
  try {
    const count = await Product.countDocuments();
    if (count === 0) {
      return res.status(404).json({ message: "No products found" });
    }
    return res.status(200).json({ count });
  } catch (error) {
    console.error("Error fetching products count:", error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.createProduct = async (req, res) => {
  try {
    const uploadImage = util.promisify(
      mediaHelper.upload.fields([
        { name: "thumbnail", maxCount: 1 },
        { name: "images", maxCount: 10 },
      ]),
    );
    try {
      await uploadImage(req, res);
    } catch (error) {
      return res.status(400).json({ type: error.code, message: `${error.message},${error.field}`, storageErrors: error.storageErrors });
    }

    const category = await Category.findById(req.body.category);
    if (!category) return res.status(404).json({ message: "Category not found" });
    if (category.markForDeletion) {
      return res.status(400).json({ message: "Category is marked for deletion" });
    }

    const thumbnail = req.files["thumbnail"][0];
    if (!thumbnail) {
      return res.status(400).json({ message: "Thumbnail image is required" });
    }
    req.body["thumbnail"] = `${req.protocol}://${req.get("host")}/${thumbnail.path}`;

    const gallery = req.files["images"];
    const imagePath = [];
    if (gallery) {
      gallery.forEach((image) => {
        imagePath.push(`${req.protocol}://${req.get("host")}/${image.path}`);
      });
    }
    if (imagePath.length > 0) {
      req.body["images"] = imagePath;
    }
    const product = await new Product(req.body).save();
    if (!product) {
      return res.status(500).json({ message: "Failed to create product" });
    }
    return res.status(201).json({ message: "Product created successfully", product });
  } catch (error) {
    if (error instanceof multer.MulterError) {
      return res.status(400).json({ type: error.code, message: error.message });
    }
    console.error("Error creating product:", error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.updateProduct = async (req, res) => {
  const productId = req.params.id;

  try {
    let product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    const { category } = req.body;
    if (category) {
      const categoryExists = await Category.findById(category);
      if (!categoryExists) {
        return res.status(404).json({ message: "Category not found" });
      }
      if (categoryExists.markForDeletion) {
        return res.status(400).json({ message: "Category is marked for deletion" });
      }
      if (req.body.images) {
        const limit = 10 - product.images.length;
        const uploadGallery = util.promisify(mediaHelper.upload.fields([{ name: "images", maxCount: limit }]));
        try {
          await uploadGallery(req, res);
        } catch (error) {
          return res.status(400).json({ type: error.code, message: `${error.message},${error.field}`, storageErrors: error.storageErrors });
        }
        const imageFiles = req.files["images"];
        const galleryUpdate = imageFiles && imageFiles.length > 0;
        if (galleryUpdate) {
          const imagePath = [];
          imageFiles.forEach((image) => {
            imagePath.push(`${req.protocol}://${req.get("host")}/${image.path}`);
          });
          req.body["images"] = [...product.images, ...imagePath];
        }
      }
      if (req.body.thumbnail) {
        const uploadThumbnail = util.promisify(mediaHelper.upload.single("thumbnail"));
        try {
          await uploadThumbnail(req, res);
        } catch (error) {
          return res.status(400).json({ type: error.code, message: `${error.message},${error.field}`, storageErrors: error.storageErrors });
        }
        const thumbnail = req.file["thumbnail"][0];
        if (thumbnail) {
          req.body["thumbnail"] = `${req.protocol}://${req.get("host")}/${thumbnail.path}`;
        }
      }
    }
    const updatedProduct = await Product.findByIdAndUpdate(productId, req.body, { new: true });
    if (!updatedProduct) {
      return res.status(500).json({ message: "Failed to update product" });
    }
    return res.status(200).json({ message: "Product updated successfully", product: updatedProduct });
  } catch (error) {
    if (error instanceof multer.MulterError) {
      return res.status(400).json({ type: error.code, message: error.message });
    }
    console.error("Error updating product:", error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.deleteProductImages = async (req, res) => {
  const productId = req.params.id;
  const { deleteImages } = req.body;
  try {
    await mediaHelper.deleteImages(deleteImages, "ENOENT");
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }
    product.images = product.images.filter((image) => !deleteImages.includes(image));
    await product.save();
    return res.status(200).json({ message: "Product images deleted successfully", product });
  } catch (error) {
    console.error("Error deleting product images:", error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.deleteProduct = async (req, res) => {
  const productId = req.params.id;
  try {
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }
    await mediaHelper.deleteImages([product.thumbnail, ...product.images], "ENOENT");
    await Review.deleteMany({ _id: { $in: product.reviews } });
    await Product.findByIdAndDelete(productId);
    return res.status(200).json({ message: "Product deleted successfully" });
  } catch (error) {
    console.error("Error deleting product:", error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getProducts = async (req, res) => {
  const page = req.query.page || 1;
  const limit = 10;
  const skip = (page - 1) * limit;
  try {
    const products = await Product.find().skip(skip).limit(limit);
    if (products.length === 0) {
      return res.status(404).json({ message: "No products found" });
    }
    return res.status(200).json({ products });
  } catch (error) {
    console.error("Error fetching products:", error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
