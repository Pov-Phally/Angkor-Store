/**
 * Seed Categories + Products
 * Run with: node seed_products.js
 */

const mongoose = require("mongoose");
require("dotenv").config();

const Category = require("./models/category");
const Product = require("./models/product");

const categories = [
  {
    name: "T-Shirts",
    color: "#FF6B6B",
    image: "https://placehold.co/400x400?text=T-Shirts",
  },
  {
    name: "Pants",
    color: "#4ECDC4",
    image: "https://placehold.co/400x400?text=Pants",
  },
  {
    name: "Shoes",
    color: "#45B7D1",
    image: "https://placehold.co/400x400?text=Shoes",
  },
  {
    name: "Accessories",
    color: "#96CEB4",
    image: "https://placehold.co/400x400?text=Accessories",
  },
];

const productTemplates = [
  {
    name: "Classic White T-Shirt",
    description: "A comfortable everyday white t-shirt made from 100% cotton.",
    price: 12.99,
    color: ["White", "Black", "Grey"],
    size: ["S", "M", "L", "XL"],
    genderAgeCategory: "unisex",
    countInStock: 100,
    categoryIndex: 0,
    image: "https://placehold.co/600x600?text=White+T-Shirt",
  },
  {
    name: "Slim Fit Black T-Shirt",
    description: "Slim fit black t-shirt for a modern casual look.",
    price: 14.99,
    color: ["Black", "Navy"],
    size: ["S", "M", "L"],
    genderAgeCategory: "men",
    countInStock: 80,
    categoryIndex: 0,
    image: "https://placehold.co/600x600?text=Black+T-Shirt",
  },
  {
    name: "Floral Print T-Shirt",
    description: "Bright floral print t-shirt perfect for summer.",
    price: 16.99,
    color: ["Pink", "Blue"],
    size: ["XS", "S", "M", "L"],
    genderAgeCategory: "women",
    countInStock: 60,
    categoryIndex: 0,
    image: "https://placehold.co/600x600?text=Floral+T-Shirt",
  },
  {
    name: "Classic Blue Jeans",
    description: "Straight-cut blue denim jeans with a comfortable fit.",
    price: 39.99,
    color: ["Blue", "Dark Blue"],
    size: ["28", "30", "32", "34", "36"],
    genderAgeCategory: "men",
    countInStock: 75,
    categoryIndex: 1,
    image: "https://placehold.co/600x600?text=Blue+Jeans",
  },
  {
    name: "Black Slim Pants",
    description: "Versatile slim-fit black trousers for everyday wear.",
    price: 34.99,
    color: ["Black"],
    size: ["28", "30", "32", "34"],
    genderAgeCategory: "unisex",
    countInStock: 50,
    categoryIndex: 1,
    image: "https://placehold.co/600x600?text=Black+Pants",
  },
  {
    name: "Running Sneakers",
    description: "Lightweight running sneakers with cushioned sole.",
    price: 59.99,
    color: ["White", "Black", "Red"],
    size: ["38", "39", "40", "41", "42", "43", "44"],
    genderAgeCategory: "unisex",
    countInStock: 90,
    categoryIndex: 2,
    image: "https://placehold.co/600x600?text=Sneakers",
  },
  {
    name: "Leather Loafers",
    description:
      "Classic leather loafers suitable for casual and semi-formal occasions.",
    price: 79.99,
    color: ["Brown", "Black"],
    size: ["39", "40", "41", "42", "43", "44"],
    genderAgeCategory: "men",
    countInStock: 40,
    categoryIndex: 2,
    image: "https://placehold.co/600x600?text=Loafers",
  },
  {
    name: "Canvas Tote Bag",
    description: "Durable canvas tote bag for daily use.",
    price: 19.99,
    color: ["Beige", "Black", "Navy"],
    size: ["One Size"],
    genderAgeCategory: "unisex",
    countInStock: 120,
    categoryIndex: 3,
    image: "https://placehold.co/600x600?text=Tote+Bag",
  },
  {
    name: "Leather Belt",
    description: "Genuine leather belt with a classic silver buckle.",
    price: 24.99,
    color: ["Black", "Brown"],
    size: ["S", "M", "L", "XL"],
    genderAgeCategory: "unisex",
    countInStock: 70,
    categoryIndex: 3,
    image: "https://placehold.co/600x600?text=Leather+Belt",
  },
  {
    name: "Kids Colorful T-Shirt",
    description: "Fun and colorful t-shirt for active kids.",
    price: 9.99,
    color: ["Red", "Yellow", "Green"],
    size: ["3-4Y", "5-6Y", "7-8Y", "9-10Y"],
    genderAgeCategory: "kids",
    countInStock: 85,
    categoryIndex: 0,
    image: "https://placehold.co/600x600?text=Kids+T-Shirt",
  },
];

async function seed() {
  await mongoose.connect(process.env.MONGODB_URI);
  console.log("Connected to MongoDB");

  // Upsert categories
  const categoryDocs = [];
  for (const cat of categories) {
    const doc = await Category.findOneAndUpdate({ name: cat.name }, cat, {
      upsert: true,
      returnDocument: "after",
    });
    categoryDocs.push(doc);
    console.log(`Category: ${doc.name} (${doc._id})`);
  }

  // Insert products
  let created = 0;
  for (const tpl of productTemplates) {
    const { categoryIndex, ...fields } = tpl;
    const exists = await Product.findOne({ name: fields.name });
    if (exists) {
      console.log(`  Skip (exists): ${fields.name}`);
      continue;
    }
    const product = await Product.create({
      ...fields,
      category: categoryDocs[categoryIndex]._id,
    });
    console.log(`  Created product: ${product.name} ($${product.price})`);
    created++;
  }

  console.log(
    `\nDone! Created ${created} products across ${categoryDocs.length} categories.`,
  );
  await mongoose.disconnect();
}

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});
