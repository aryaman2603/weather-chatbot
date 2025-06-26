import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/services/api_helper.dart';
import '/models/weather.dart';
final cityForecastProvider = FutureProvider.autoDispose.family<Weather, String>(
  (ref, cityName) => ApiHelper.getWeatherByCityName(
    cityName: cityName,
  ),
);