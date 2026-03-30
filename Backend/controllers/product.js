const Product = require("../models/product");

exports.getProducts = async (req, res) => {
  try {
    let products;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;
    if (req.query.criteria) {
      let query = {};
      if (req.query.criteria) {
        query["category"] = req.query.criteria;
      }
      switch (req.query.criteria) {
        case "newArrivals": {
          const twoWeeksAgo = new Date();
          twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
          query["dateAdded"] = { $gte: twoWeeksAgo };
          break;
        }
        case "popular": {
          query["rating"] = { $gte: 4 };
          break;
        }
        default:
          break;
      }
      products = await Product.find(query).skip(skip).limit(limit);
    } else if (req.query.category) {
      products = await Product.find({ category: req.query.category }).skip(skip).limit(limit);
    } else {
      products = await Product.find().skip(skip).limit(limit);
    }
    return res.status(200).json(products);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.serchProducts = async (req, res) => {
  try {
    const searchTerm = req.query.q;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    let query = {};
    if (req.query.category) {
      query = { category: req.query.category };
      if (req.query.genderAgeCategory) {
        query["genderAgeCategory"] = req.query.genderAgeCategory.toLowerCase();
      }
    } else if (req.query.genderAgeCategory) {
      query = { genderAgeCategory: req.query.genderAgeCategory.toLowerCase() };
    }
    if (searchTerm) {
      query = {
        ...query,
        $text: { $search: searchTerm, $caseSensitive: false, $language: "en" },
        category: req.query.category,
      };
    }
    const searchResult = await Product.find(query).skip(skip).limit(limit);
    return res.status(200).json(searchResult);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getProductById = async (req, res) => {
  try {
    const productId = req.param.id;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: error.name, message: "Product not found" });
    }
    return res.status(200).json(product);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
