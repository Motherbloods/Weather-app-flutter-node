const axios = require("axios");
require("dotenv").config();

async function fetchWeatherData(lat, lon) {
  const apiKey = process.env.API_KEY;
  const url = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}`;
  try {
    const response = await axios.get(url);
    const currentWeather = response.data;
    const temperature = (currentWeather.main.temp - 273.15).toFixed(2);
    return {
      latitude: lat,
      longitude: lon,
      temperature: temperature,
      humidity: currentWeather.main.humidity,
      description: currentWeather.weather[0].description,
      timestamp: new Date(currentWeather.dt * 1000),
    };
  } catch (err) {
    console.error("Error fetching weather data:" + err);
    return null;
  }
}

function checkExtremeWeather(weatherData) {
  const extremeConditions = [];

  if (weatherData.temperature > 35) extremeConditions.push("extreme heat");
  if (weatherData.temperature < -10) extremeConditions.push("extreme cold");
  if (weatherData.description.includes("heavy rain"))
    extremeConditions.push("heavy rain");
  if (weatherData.windSpeed > 20) extremeConditions.push("strong wind");

  return extremeConditions;
}

module.exports = { fetchWeatherData, checkExtremeWeather };
// fetchWeatherData();
