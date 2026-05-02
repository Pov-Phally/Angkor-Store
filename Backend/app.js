const dns = require("dns");
dns.setServers(["8.8.8.8", "8.8.4.4"]);
const bodyParser = require("body-parser");
const express = require("express");
const morgan = require("morgan");
const cors = require("cors");
const mongoose = require("mongoose");
const authJwt = require("./middlewares/jwt");
const authorizePostRequests = require("./middlewares/authorization");
const errorHandler = require("./middlewares/error_handler");
require("dotenv").config();

const app = express();
const apiUrl = process.env.API_URL;

// Middleware
app.use(bodyParser.json());
app.use(morgan("tiny"));
app.use(cors());
app.options("/{*path}", cors());
app.use(authJwt());
app.use(authorizePostRequests);
app.use(errorHandler);

// Routes
const authRoutes = require("./routes/auth");
const userRoutes = require("./routes/users");
const adminRoutes = require("./routes/admin");
const categoryRoutes = require("./routes/category");
const productRoutes = require("./routes/product");
const checkoutRoutes = require("./routes/checkout");
const orderRoutes = require("./routes/order");

// Use routes
app.use(`/${apiUrl}/auth`, authRoutes);
app.use(`/${apiUrl}/users`, userRoutes);
app.use(`/${apiUrl}/admin`, adminRoutes);
app.use(`/${apiUrl}/categories`, categoryRoutes);
app.use(`/${apiUrl}/products`, productRoutes);
app.use(`/${apiUrl}/checkout`, checkoutRoutes);
app.use(`/${apiUrl}/orders`, orderRoutes);
app.use("/public", express.static(__dirname + "/public"));

require("./helpers/cron_job");

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Error connecting to MongoDB:", err));

// Start the server
app.listen(process.env.PORT, process.env.LOCALHOST, () => {
  console.log(`Server running at http://${process.env.LOCALHOST}:${process.env.PORT}`);
});
