import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:weather_app_tutorial/constants/constants.dart';
import 'package:weather_app_tutorial/models/hourly_weather.dart';
import 'package:weather_app_tutorial/models/weather.dart';
import 'package:weather_app_tutorial/models/weekly_weather.dart';
import 'package:weather_app_tutorial/services/geolocator.dart';

@immutable 
class ApiHelper {
  static const baseUrl = "https://api.openweathermap.org/data/2.5";
  static const weeklyWeatherUrl = 'https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';
  
  static double lat = 0.0;
  static double lon = 0.0;
  static final dio = Dio();

  static Future<void> fetchLocation() async{
    final location = await getLocation();
    lat = location.latitude;
    lon = location.longitude;
  }

  static Future<Weather> getCurrentWeather() async{
    await fetchLocation();
    final url = _constructWeatherUrl();
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  static Future<HourlyWeather> getHourlyForecast() async {
    await fetchLocation();
    final url = _constructForecastUrl();
    final response = await _fetchData(url);
    return HourlyWeather.fromJson(response);
  }

  //* Weekly weather
  static Future<WeeklyWeather> getWeeklyForecast() async {
    await fetchLocation();
    final url = _constructWeeklyForecastUrl();
    final response = await _fetchData(url);
    return WeeklyWeather.fromJson(response);
  }

  //* Weather by City Name
  static Future<Weather> getWeatherByCityName({
    required String cityName,
  }) async {
    final url = _constructWeatherByCityUrl(cityName);
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  //! Build urls
  static String _constructWeatherUrl() =>
      '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructForecastUrl() =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructWeatherByCityUrl(String cityName) =>
      '$baseUrl/weather?q=$cityName&units=metric&appid=${Constants.apiKey}';

  static String _constructWeeklyForecastUrl() =>
      '$weeklyWeatherUrl&latitude=$lat&longitude=$lon';

  static Future<Map<String, dynamic>> _fetchData(String url) async{
    try{
      final response = await dio.get(url);

      if(response.statusCode==200){
        return response.data;
      }
      else{
        throw Exception('Failed to load data');
      }

    }
    catch(e){
      throw Exception('Error fetching data');
    }
  }    
}