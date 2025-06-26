import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/extensions/datetime.dart';
import 'package:weather_app_tutorial/providers/weekly_weather_provider.dart';
import 'package:weather_app_tutorial/utils/get_weather_icons.dart';
import 'package:weather_app_tutorial/widgets/subscript_text.dart';

class WeeklyForecastView extends ConsumerWidget {
  const WeeklyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final weeklyForecastData = ref.watch(weeklyWeatherProvier);
    return weeklyForecastData.when(
      data: (weeklyWeather) {
        return ListView.builder(
          itemCount: weeklyWeather.daily.weatherCode.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final dayOfWeek =
                DateTime.parse(weeklyWeather.daily.time[index]).dayOfWeek;
            final date = weeklyWeather.daily.time[index];
            final temp = weeklyWeather.daily.temperature2mMax[index];
            final icon = weeklyWeather.daily.weatherCode[index];

            return WeeklyWeatherTile(
              date: date,
              day: dayOfWeek,
              temp: temp,
              icon: getWeatherIcon2(icon),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString(), style: TextStyle(color: Colors.white)),
        );
      },
      loading: () {
        return CircularProgressIndicator();
      },
    );
  }
}

class WeeklyWeatherTile extends StatelessWidget {
  WeeklyWeatherTile({
    super.key,
    required this.date,
    required this.day,
    required this.icon,
    required this.temp,
  });

  final String day;
  final String date;
  final double temp;
  final String icon;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.accentBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(date, style: TextStyle(color: Colors.white)),
            ],
          ),
          SuperscriptText(
            text: temp.toString(),
            superScript: "C",
            color: Colors.white,
            superscriptColor: AppColors.grey,
          ),
          Image.asset(icon, width: 50,)
        ],
      ),
    );
  }
}
