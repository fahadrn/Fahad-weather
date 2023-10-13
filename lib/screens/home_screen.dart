// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/ui_elements/blueGradient.dart';
import 'package:weather/api/api_key.dart';
import 'package:weather/controller/global_controller.dart';
import 'package:weather/model/WeatherDataModel.dart';
import 'package:weather/widgets/Hourly_details.widget.dart';
import 'package:weather/widgets/current_weather_widget.dart';
import 'package:http/http.dart' as http;
import 'package:weather/widgets/header_widget.dart';
// import 'package:weather/widgets/hour_data_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WeatherDataModel currentWeather;
  bool isLoading = false;
  bool isLoaded = false;

  Future<void> fetchCurrentLocationClimateDetails() async {
    setState(() {
      isLoading = true;
    });

    var lat;
    var lon;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      lat = value.latitude;
      lon = value.longitude;
    });
    String url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$lat,$lon";

    var response = await http.get(Uri.parse(url));
    WeatherDataModel data = WeatherDataModel.fromRawJson(response.body);

    setState(() {
      currentWeather = data;
      isLoaded = true;
      isLoading = false;
    });
  }

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  void initState() {
    fetchCurrentLocationClimateDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 89, 119),
      body: SafeArea(
        child: Obx(
          () => globalController.checkLoading().isTrue
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/clouds.png',
                        height: 200,
                        width: 200,
                        color: Colors.white,
                      ),
                      CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(255, 14, 89, 119),
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: blueGradient,
                  ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        children: [
                          HeaderWidget(
                              currentWeather: currentWeather, isHome: true),
                          SizedBox(
                            height: 20,
                          ),
                          CurrentWeatherWidget(
                            currentWeather: currentWeather,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      HourlyDetails(currentWeather: currentWeather),
                      // SizedBox(
                      //   height: 50,
                      // )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
