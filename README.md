# 🌦️ Weather Chatbot App

A full-stack Flutter application that combines real-time weather updates and an AI-powered chatbot for weather-related queries. Built using **Flutter (MVVM pattern)** for the frontend and **FastAPI with Google Gemini API** for the backend.

---

## 🚀 Features

- 🌍 **Weather UI** with 3 tabs:
  - Current weather info
  - Search functionality
  - Hourly/daily forecast
- 💬 **Chatbot tab** powered by Gemini API to answer weather-related questions in natural language
- 🔁 **MVVM architecture**: separation of Models, Views, and ViewModels
- 📡 **HTTP integration** between frontend and backend
- ☁️ **OpenWeatherMap API** for accurate weather data

---

## 🗂️ Project Structure

```bash
weather-chatbot/
├── backend/                  # FastAPI app with Gemini integration
│   ├── main.py              # FastAPI server with chat endpoint
│   ├── check_models.py        
│   └── .env                 # API keys
│   └── .requirements.txt
│
└── weather_app_tutorial/    # Flutter frontend
    ├── lib/
    │   ├── models/          # Data models
    │   ├── providers/       # State management logic
    │   ├── views/           # UI screens for each tab
    │   ├── services/        # API calling logic
    │   └── main.dart
    └── pubspec.yaml
