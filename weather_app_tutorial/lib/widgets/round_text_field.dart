import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/screens/weather_detail_screen.dart';

class RoundTextField extends StatelessWidget{
  const RoundTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 10, 51, 85)
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top:10),
          border: InputBorder.none,
          fillColor: Colors.white,
          focusColor: Colors.white,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
          
        ),
        onSubmitted: (value){
          final query = value.trim();
          if(query.isNotEmpty){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_)=>WeatherDetailScreen(cityName: query))
            );
          }
        },
      ),
    );
  }
}