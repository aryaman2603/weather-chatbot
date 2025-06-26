import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/views/hourly_forecast_view.dart';

import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/extensions/strings.dart';
import '/providers/city_weather_provider.dart';
import '/views/weather_info.dart';
import '/views/gradient_container.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({
    super.key,
    required this.cityName,
  });

  final String cityName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch((cityForecastProvider(cityName)));

    return Scaffold(
      //appBar: AppBar(leading: BackButton(),),
      body: weatherData.when(
        data: (weather) {
          return GradientContainer(
  children: [
    const SizedBox(height: 30),
    
    // Back button aligned to top-left
    Row(
      children: const [
        BackButton(color: Colors.white,),
      ],
    ),

    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //const SizedBox(height: 30, width: double.infinity),

        // Country name
        Text(
          weather.name,
          style: TextStyles.h1,
        ),

        const SizedBox(height: 20),

        // Date
        Text(
          DateTime.now().dateTime,
          style: TextStyles.subtitleText,
        ),

        const SizedBox(height: 50),

        // Icon
        SizedBox(
          height: 300,
          child: Image.asset(
            'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 50),

        // Description
        Text(
          weather.weather[0].description.capitalize,
          style: TextStyles.h2,
        ),
      ],
    ),

    const SizedBox(height: 40),

    WeatherInfo(weather: weather),

    const SizedBox(height: 15),

    HourlyForecastView(),
  ],
)
;
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text(
              'An error has occurred',
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}