import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/extensions/datetime.dart';
import 'package:weather_app_tutorial/providers/current_weather_provider.dart';
import 'package:weather_app_tutorial/views/gradient_container.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/views/weather_info.dart';
import 'package:weather_app_tutorial/views/hourly_forecast_view.dart';
class WeatherScreen extends ConsumerWidget {
  final VoidCallback onViewFullForecast;
  const WeatherScreen({super.key, required this.onViewFullForecast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final weatherData = ref.watch(currentWeatherProvier);
    
    return weatherData.when(
      data: (weather) {
        return GradientContainer(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                Text(
                  weather.name,
                  style: TextStyles.h1,
                ),
                const SizedBox(height: 20),
                Text(DateTime.now().dateTime, style: TextStyle(color: Colors.white),),
                const SizedBox(height: 30),
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
                  ),
                  //child: Icon(Icons.cloud, size: 50, color: Colors.white,),
                ),
                const SizedBox(height: 40),
                Text(weather.weather[0].description, style: TextStyles.h3),
                SizedBox(height: 40,),
                WeatherInfo(
                  weather: weather,
                ),
                const SizedBox(height: 30,),
     
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today',  style: TextStyles.h3),
                    TextButton(onPressed: onViewFullForecast, 
                    child: Text('View full forecast', style: TextStyle(color: Colors.white),)),
                  ],), 
                  HourlyForecastView(),
              ],
            ),
            
          ],
          
        );
      },
      error: (error, StackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
