import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/extensions/datetime.dart';
import 'package:weather_app_tutorial/views/gradient_container.dart';
import 'package:weather_app_tutorial/views/hourly_forecast_view.dart';
import 'package:weather_app_tutorial/views/weekly_forecast_view.dart';

class DetailedForecastScreen extends StatelessWidget{
  const DetailedForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GradientContainer(children: [
        Center(child: Text('Forecast Report', style: TextStyles.h1)),
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(DateTime.now().dateTime, style: TextStyle(color: Colors.white,))
          ],),
          SizedBox(height: 20,),
          HourlyForecastView(),
          SizedBox(height: 20 ,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Next Forecast', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            Icon(Icons.calendar_month_outlined, color: Colors.white,)
          ],),
          SizedBox(height: 20,),
          WeeklyForecastView()
      ]
      ),
    );
  }
}