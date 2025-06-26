import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/models/famous_city.dart';
import 'package:weather_app_tutorial/screens/weather_detail_screen.dart';
import '../widgets/famous_city_tile.dart';


class  FamousCitiesView extends StatelessWidget{
  const FamousCitiesView({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemCount: famousCities.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
      final city = famousCities[index];
      
      return GestureDetector(child: FamousCityTile(
        index: index,
        city: city
      ), 
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => WeatherDetailScreen(cityName: city.name))
        );
      },);
      });
  }
}