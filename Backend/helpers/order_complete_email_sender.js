const { sendEmail } = require("./email_sender");

const orderItemTemplate = (
  thumbnail,
  productName,
  quantity,
  productPrice,
  selectedColor,
  selectedSize,
) => {
  return `
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px;">
        <img src="${thumbnail}" alt="${productName}" style="width: 50px; height: 50px; object-fit: cover;">
        ${productName}
      </td>
      <td style="border: 1px solid #ddd; padding: 8px;">${quantity}</td>
      <td style="border: 1px solid #ddd; padding: 8px;">$${productPrice.toFixed(2)}</td>
      <td style="border: 1px solid #ddd; padding: 8px;">${selectedColor || "N/A"}</td>
      <td style="border: 1px solid #ddd; padding: 8px;">${selectedSize || "N/A"}</td>
    </tr>
  `;
};

exports.buildEmail = (userName, order, shippingDetailUsername) => {
  const orderTemplates = [];
  let totalPrice = 0;
  for (const orderItem of order.orderItems) {
    orderTemplates.push(
      orderItemTemplate(
        orderItem.productImage,
        orderItem.productName,
        orderItem.quantity,
        orderItem.productPrice,
        orderItem.selectColor,
        orderItem.selectSize,
      ),
    );
    totalPrice += orderItem.productPrice * orderItem.quantity;
  }
  const orderRows = orderTemplates.join("");
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Order Complete</title>
  <style>
    table {
      border-collapse: collapse;
      width: 100%;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 8px;
      text-align: left;
    }
    th {
      background-color: #f2f2f2;
    }
    .total {
      font-weight: bold;
      font-size: 18px;
      text-align: right;
    }
  </style>
</head>
<body>
  <h1>Order Complete</h1>
  <p>Hi ${userName},</p>
  <p>Your order has been completed successfully.</p>
  <h2>Order Details</h2>
  <p><strong>Shipping Address:</strong> ${order.shippingAddress}, ${order.city}, ${order.postalCode}, ${order.country}</p>
  <p><strong>Phone:</strong> ${order.phone}</p>
  <table>
    <thead>
      <tr>
        <th>Product</th>
        <th>Quantity</th>
        <th>Price</th>
        <th>Color</th>
        <th>Size</th>
      </tr>
    </thead>
    <tbody>
      ${orderRows}
    </tbody>
  </table>
  <p class="total">Total: $${totalPrice.toFixed(2)}</p>
  <p>Thank you for shopping with us!</p>
</body>
</html>`;
};

exports.sendOrderCompleteEmail = async (userEmail, userName, order, shippingDetailUsername) => {
  const html = this.buildEmail(userName, order, shippingDetailUsername);
  await sendEmail(userEmail, "Order Completed", null, html);
};
