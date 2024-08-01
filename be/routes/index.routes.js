const express = require("express");
const router = express.Router();

const {
  getWeatherData,
  getWeatherHistory,
} = require("../controllers/weather.controller");
const { login } = require("../controllers/user.controller");
const User = require("../models/user");
const { sendPushNotification } = require("../services/notificationService");
router.get("/api/weather", getWeatherData);
router.get("/api/weather/history", getWeatherHistory);

router.post("/simulate-extreme-weather", async (req, res) => {
  const { userId, lat, lon, conditions } = req.body;
  console.log(req.body);
  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    await sendPushNotification(user, `${lat},${lon}`, conditions);

    res.json({
      message: "Extreme weather notification simulated successfully",
    });
  } catch (error) {
    console.error("Error simulating extreme weather:", error);
    res
      .status(500)
      .json({ error: "Failed to simulate extreme weather notification" });
  }
});

router.post("/api/login", login);
module.exports = router;
