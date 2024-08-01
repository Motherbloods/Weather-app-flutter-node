const Weather = require("../models/weather");
const { fetchWeatherData } = require("../services/weather");

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

module.exports = { getWeatherData, getWeatherHistory };
