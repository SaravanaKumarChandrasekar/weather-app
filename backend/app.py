from flask import Flask, request, jsonify
import requests
import os

app = Flask(__name__)

# Load API key from environment variable (set in docker-compose.yml)
API_KEY = os.getenv("OPENWEATHER_API_KEY")

@app.route('/weather')
def weather():
    city = request.args.get('q')
    if not city:
        return jsonify({"error": "City name required"}), 400

    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&units=metric&appid={API_KEY}"
    response = requests.get(url)
    return jsonify(response.json())

@app.route('/forecast')
def forecast():
    city = request.args.get('q')
    if not city:
        return jsonify({"error": "City name required"}), 400

    url = f"http://api.openweathermap.org/data/2.5/forecast?q={city}&units=metric&appid={API_KEY}"
    response = requests.get(url)
    return jsonify(response.json())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

