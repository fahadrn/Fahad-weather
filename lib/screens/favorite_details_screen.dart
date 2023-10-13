// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/api/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:weather/controller/global_controller.dart';
import 'package:weather/model/WeatherDataModel.dart';
import 'package:weather/ui_elements/blueGradient.dart';
import 'package:weather/widgets/Hourly_details.widget.dart';
import 'package:weather/widgets/current_weather_widget.dart';
import 'package:weather/widgets/header_widget.dart';

class FavoriteDetailsScreen extends StatefulWidget {
  String location;
  FavoriteDetailsScreen({super.key, required this.location});

  @override
  State<FavoriteDetailsScreen> createState() => _FavoriteDetailsScreenState();
}

class _FavoriteDetailsScreenState extends State<FavoriteDetailsScreen> {
  late WeatherDataModel currentWeather;
  final TextEditingController locationSearchField = TextEditingController();
  bool isLoading = false;
  List<String> favoriteLocations = [];
  bool isLocationInFavorites(String location) {
    return favoriteLocations.contains(location);
  }

  Future<void> removeFromFavorite() async {
    favoriteLocations.remove(locationSearchField.text);
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences
        .setStringList('favoriteLocations', favoriteLocations)
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.white,
                    duration: Duration(seconds: 1),
                    content: Text(
                      "Removed from Favorites",
                      style: TextStyle(color: Color.fromARGB(255, 14, 89, 119)),
                    )),
              ),
            });
  }

  Future<void> fetchFavoriteDetails() async {
    setState(() {
      isLoading = true;
    });
    String url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=${widget.location}";
    var response = await http.get(Uri.parse(url));
    WeatherDataModel data = WeatherDataModel.fromRawJson(response.body);
    setState(() {
      currentWeather = data;
      isLoading = false;
    });
  }

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  void initState() {
    fetchFavoriteDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 14, 89, 119),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                  backgroundColor: Color.fromARGB(255, 14, 89, 119),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  gradient: blueGradient,
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      children: [
                        HeaderWidget(
                            currentWeather: currentWeather, isHome: false),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CurrentWeatherWidget(
                      currentWeather: currentWeather,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    HourlyDetails(currentWeather: currentWeather)
                  ],
                ),
              ),
      ),
    );
  }
}
