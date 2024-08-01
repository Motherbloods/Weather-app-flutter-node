const mongoose = require("mongoose");

const weatherSchema = new mongoose.Schema({
  lat: Number,
  lon: Number,
  location: String,
  temperature: Number,
  humidity: Number,
  description: String,
  windSpeed: Number,
  timestamp: Date,
});

const Weather = mongoose.model("Weather", weatherSchema);

module.exports = Weather;
