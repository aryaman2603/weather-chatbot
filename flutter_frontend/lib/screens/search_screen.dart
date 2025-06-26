import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/views/gradient_container.dart';
import '../widgets/round_text_field.dart';
import '../views/famous_cities_view.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GradientContainer(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(
            'Pick Location',
            style: TextStyles.h1,
          ),
          const SizedBox(height: 30),
          Text(
            'Find the area or the city that you want to know the detailed weather info at this time',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: RoundTextField(controller: _controller)),
              SizedBox(width: 15,),
              LocationIcon()
            ],
          ),
          SizedBox(height: 30,),
          //Famous Cities View
          FamousCitiesView()
        ],
      ),
    );
  }
}

class LocationIcon extends StatelessWidget{
  const LocationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 10, 51, 85)
      ),
      child: Icon(Icons.search,color: Colors.white,),
    );
  }
}
