import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/services/api_helper.dart';

final weeklyWeatherProvier = FutureProvider.autoDispose((ref) async{
return ApiHelper.getWeeklyForecast();  
});