const app = require("./utils/config");
const port = process.env.PORT || 8000;
const cron = require("node-cron");
const initializeFirebase = require("./utils/firebase");
const { fetchWeatherData, checkExtremeWeather } = require("./services/weather");
const { sendPushNotification } = require("./services/notificationService");
const { connectToDatabase } = require("./utils/db");
const routes = require("./routes/index.routes");
const User = require("./models/user");
require("dotenv").config();
// Fungsi untuk menjalankan cron job
async function runWeatherCronJob() {
  try {
    const users = await User.find();

    for (const user of users) {
      for (const location of user.locations) {
        // Parse the location string to get lat and lon
        const [lat, lon] = location
          .split(",")
          .map((coord) => parseFloat(coord.trim()));

        if (isNaN(lat) || isNaN(lon)) {
          console.error(
            `Invalid location format for user ${user.email}: ${location}`
          );
          continue;
        }

        const weatherData = await fetchWeatherData(lat, lon);
        if (weatherData) {
          console.log(`Weather data fetched for location: ${lat}, ${lon}`);

          const extremeConditions = checkExtremeWeather(weatherData);
          if (extremeConditions.length > 0) {
            const relevantConditions = extremeConditions.filter(
              (condition) =>
                user.notificationPreferences[condition.replace(" ", "")]
            );
            if (relevantConditions.length > 0) {
              await sendPushNotification(
                user,
                `${lat},${lon}`,
                relevantConditions
              );
            }
          }
        }
      }
    }
  } catch (error) {
    console.error("Error in weather cron job:", error);
  }
}

// Fungsi utama untuk menjalankan aplikasi
async function startApp() {
  try {
    await connectToDatabase();
    initializeFirebase();

    app.use(routes);

    cron.schedule("*/15 * * * *", runWeatherCronJob);

    app.listen(port, () => {
      console.log("Listening on port " + port);
    });
  } catch (error) {
    console.error("Failed to start application:", error);
    process.exit(1);
  }
}

// Jalankan aplikasi
startApp();
