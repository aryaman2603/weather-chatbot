from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
from dotenv import load_dotenv
import google.generativeai as genai
import json
import requests
from typing import Literal
from datetime import datetime

# Load environment variables
load_dotenv()

GOOGLE_API_KEY = os.getenv("GEMINI_API_KEY")
WEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY")

if not GOOGLE_API_KEY or not WEATHER_API_KEY:
    raise ValueError("Missing required API keys in .env file")

# Configure Gemini
genai.configure(api_key=GOOGLE_API_KEY)

# FastAPI app setup
app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:8080",
    "http://127.0.0.1:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Weather retrieval function
def get_weather(location: str, unit: Literal["celsius", "fahrenheit"] = "celsius"):
    base_url = "http://api.openweathermap.org/data/2.5/weather"
    params = {
        "q": location,
        "appid": WEATHER_API_KEY,
        "units": "metric" if unit == "celsius" else "imperial"
    }
    try:
        response = requests.get(base_url, params=params)
        data = response.json()
        if response.status_code == 200:
            return {
                "location": data["name"],
                "temperature": data["main"]["temp"],
                "unit": unit,
                "conditions": data["weather"][0]["description"],
                "humidity": data["main"]["humidity"],
                "wind_speed": data["wind"]["speed"],
                "timestamp": datetime.now().isoformat()
            }
        else:
            return {"error": f"Weather API error: {data.get('message', 'Unknown error')}"}
    except Exception as e:
        return {"error": f"Failed to get weather: {str(e)}"}

# Request schema
class ChatRequest(BaseModel):
    message: str

# Gemini-based query processor
def process_weather_query(query: str) -> str:
    tools = [{
        "name": "get_weather",
        "description": "Get current weather information for a location",
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "City name or location"
                },
                "unit": {
                    "type": "string",
                    "enum": ["celsius", "fahrenheit"],
                    "description": "Temperature unit",
                    "default": "celsius"
                }
            },
            "required": ["location"]
        }
    }]

    try:
        model = genai.GenerativeModel('gemini-1.5-flash-8b-001')
        location_prompt = f"Extract the city or country name from this query: {query}"
        location_response = model.generate_content(location_prompt)
        location = location_response.text.strip()
        weather_data = get_weather(location=location)
        context = f"Given the query '{query}' and weather data: {json.dumps(weather_data, indent=2)}, provide a natural language response."
        final_response = model.generate_content(context)
        return final_response.text
    except Exception as e:
        return f"Error: {str(e)}"

# Chat endpoint
@app.post("/chat")
async def chat_with_gemini(request: ChatRequest):
    try:
        return {"response": process_weather_query(request.message)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to process request: {e}")

# Health check
@app.get("/")
async def root():
    return {"message": "Gemini weather backend using prompt-based extraction is running."}
