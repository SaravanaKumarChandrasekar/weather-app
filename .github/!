import pytest
from app import app

@pytest.fixture
def client():
    app.testing = True
    with app.test_client() as client:
        yield client

def test_home(client):
    response = client.get("/")
    assert response.status_code == 200
    assert b"Welcome to Weather App!" in response.data

def test_weather_route(client):
    response = client.get("/weather/London")
    assert response.status_code in [200, 404]  # City may exist or not
    data = response.get_json()
    assert "city" in data or "error" in data

