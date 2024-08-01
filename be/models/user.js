const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  email: String,
  locations: [String],
  notificationPreferences: {
    extremeHeat: Boolean,
    extremeCold: Boolean,
    heavyRain: Boolean,
    strongWind: Boolean,
  },
  fcmToken: String,
});

const User = mongoose.model("User_Weather", userSchema);

module.exports = User;
