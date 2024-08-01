const express = require("express");
const router = express.Router();

const {
  getWeatherData,
  getWeatherHistory,
} = require("../controllers/weather.controller");
const { login } = require("../controllers/user.controller");

router.get("/api/weather", getWeatherData);
router.get("/api/weather/history", getWeatherHistory);

router.post("/api/login", login);
module.exports = router;
