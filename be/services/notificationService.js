const admin = require("firebase-admin");

exports.sendPushNotification = async (user, location, conditions) => {
  if (!user.fcmToken) return;

  const message = {
    notification: {
      title: `Extreme Weather Alert for ${location}`,
      body: `Warning: ${conditions.join(
        ", "
      )} detected in ${location}. Please take necessary precautions.`,
    },
    token: user.fcmToken,
  };

  try {
    await admin.messaging().send(message);
    console.log(`Notification sent to ${user.email} for ${location}`);
  } catch (error) {
    console.error("Error sending push notification:", error);
  }
};
