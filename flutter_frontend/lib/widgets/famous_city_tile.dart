import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/providers/city_weather_provider.dart';
import 'package:weather_app_tutorial/utils/get_weather_icons.dart';
import '../models/famous_city.dart';
class FamousCityTile extends ConsumerWidget {
  const FamousCityTile({super.key, required this.city, required this.index});

  final FamousCity city;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final weatherData = ref.watch(cityForecastProvider(city.name));

    return weatherData.when(
      data: (weather) {
        return Material(
          color: index == 0 ? Colors.lightBlue : AppColors.accentBlue,
          elevation: index == 0 ? 8 : 0,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: Text(
                          '${weather.main.temp.round().toString()}°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        SizedBox(height: 10),
                        SizedBox(
                          //height: 40,
                          child: Text(
                          weather.weather[0].description,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        )),
                      ],
                    )),
                    Image.asset(getWeatherIcon(weatherCode: weather.weather[0].id),
                    width: 50,),
                  ],
                ),
                Text(
                    weather.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      error: (error, StackTrace) {
        return Center(child: Text(error.toString(),style: TextStyle(color: Colors.white),));
      },
      loading: () {
        return CircularProgressIndicator();
      },
    );
  }
}
