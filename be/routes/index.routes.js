const express = require("express");
const router = express.Router();

const {
  getWeatherData,
  getWeatherHistory,
  simulateWeather,
} = require("../controllers/weather.controller");
const { login } = require("../controllers/user.controller");
const User = require("../models/user");
const { sendPushNotification } = require("../services/notificationService");
router.get("/api/weather", getWeatherData);
router.get("/api/weather/history", getWeatherHistory);

router.post("/simulate-extreme-weather", simulateWeather);

router.post("/api/login", login);
module.exports = router;
