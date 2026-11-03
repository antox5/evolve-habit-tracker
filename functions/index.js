
const { onRequest } = require("firebase-functions/v2/https");

exports.quotes = onRequest({ cors: true }, async (req, res) => {
  try {
    if (req.method !== "GET") {
      return res.status(405).json({ error: "Method not allowed" });
    }

    const response = await fetch(
      "https://zenquotes.io/api/random"
    );

    if (!response.ok) {
      throw new Error("ZenQuotes API request failed");
    }

    const data = await response.json();

    return res.status(200).json(data);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      error: "Unable to fetch quotes"
    });
  }
});
