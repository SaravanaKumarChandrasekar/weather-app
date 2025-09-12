import os
import requests
from flask import Flask, jsonify

app = Flask(__name__)

API_KEY = os.getenv("OPENWEATHER_API_KEY")  # read key from environment
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

@app.route("/")
def home():
    return jsonify({"message": "Welcome to Weather App!"})

@app.route("/weather/<city>")
def weather(city):
    params = {
        "q": city,
        "appid": API_KEY,
        "units": "metric"  # Celsius
    }
    response = requests.get(BASE_URL, params=params)

    if response.status_code == 200:
        data = response.json()
        result = {
            "city": data["name"],
            "temperature": f"{data['main']['temp']}°C",
            "condition": data["weather"][0]["description"]
        }
        return jsonify(result)
    else:
        return jsonify({"error": "City not found"}), 404

if __name__ == "__main__":
    app.run(debug=True)

