const { User } = require("../models/user");
exports.getUsers = async (_, res) => {
  try {
    const users = await User.find().select("id name email isAdmin");
    if (!users) {
      return res.status(404).json({ error: "No users found" });
    }
    return res.status(200).json(users);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.getUserById = async (req, res) => {
  const userId = req.params.id;
  try {
    const user = await User.findById(userId).select("-passwordHash -resetPasswordOtp -resetPasswordExpires ");
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    return res.status(200).json(user);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.updateUser = async (req, res) => {
  const userId = req.params.id;
  try {
    const { name, email, phone } = req.body;
    const user = await User.findByIdAndUpdate(
      userId,
      { name, email, phone },
      { returnDocument: "after", runValidators: true },
    ).select("-passwordHash -resetPasswordOtp -resetPasswordExpires");

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    return res.status(200).json(user);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};

exports.deleteUser = async (req, res) => {
  const userId = req.params.id;
  try {
    const user = await User.findByIdAndDelete(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    return res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.name, message: error.message });
  }
};
