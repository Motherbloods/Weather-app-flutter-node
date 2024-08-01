const User = require("../models/user");

const login = async (req, res) => {
  try {
    const { email, locations, notificationPreferences, fcmToken } = req.body;
    const user = new User({
      email,
      locations,
      notificationPreferences,
      fcmToken,
    });
    await user.save();
    res.status(201).json(user);
  } catch (err) {
    console.log(err);
  }
};

const updateUser = async (req, res) => {};

module.exports = { login, updateUser };
