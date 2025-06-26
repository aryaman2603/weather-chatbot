import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/extensions/double.dart';
import 'package:weather_app_tutorial/models/weather.dart';
class WeatherInfo extends StatelessWidget{
  const WeatherInfo({super.key, required this.weather});
  
  final Weather weather;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
     padding: const EdgeInsets.symmetric(
      horizontal: 10,
     ), 
     child: Row(  
    children: [
     Padding(
      padding: EdgeInsets.only(right: 80),
      child: WeatherInfoTile(
      title: 'Temp',
      value: '${weather.main.temp}°C',
     )),
     Padding(
      padding: EdgeInsets.only(right: 50),
      child: WeatherInfoTile(
      title: 'Wind',
      value: '${weather.wind.speed.kmh} km/h',
     )),
     WeatherInfoTile(
      title: 'Humidity',
      value: '${weather.main.humidity}%',
     ),
    ],));
  }
}

class WeatherInfoTile extends StatelessWidget{
  const WeatherInfoTile({super.key, required this.title, required this.value});

  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(color: Colors.white),),
        const SizedBox(height: 10,),
        Text(value, style: TextStyle(color: Colors.white),)
      ],
    );
  }
}