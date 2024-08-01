const User = require("../models/user");
const Weather = require("../models/weather");
const { fetchWeatherData } = require("../services/weather");
const { sendPushNotification } = require("../services/notificationService");
const getWeatherData = async (req, res) => {
  try {
    const { lat, lon } = req.query;
    console.log("ini tes");
    if (!lat || !lon) {
      return res
        .status(400)
        .json({ error: "Latitude and longitude are required" });
    }

    const weatherData = await Weather.findOne({ lat, lon }).sort({
      timestamp: -1,
    });

    const weatherFetch = await fetchWeatherData(lat, lon);
    res.json(weatherFetch);
  } catch (err) {
    console.error(err);
  }
};
const getWeatherHistory = async (req, res) => {
  try {
    const { lat, lon } = req.query;
    if (!lat || !lon) {
      return res
        .status(400)
        .json({ error: "Latitude and longitude are required" });
    }

    const weatherHistory = await Weather.find({ lat, lon })
      .sort({ timestamp: -1 })
      .limit(24);
    res.json(weatherHistory);
  } catch (err) {
    console.error(err);
  }
};

const simulateWeather = async (req, res) => {
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
};
module.exports = { getWeatherData, getWeatherHistory, simulateWeather };
