// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/model/WeatherDataModel.dart';
import 'package:weather/model/weather_data_current.dart';
import 'package:weather/widgets/Hourly_details.widget.dart';
import 'package:weather/widgets/current_weather_widget.dart';
import 'package:weather/widgets/header_widget.dart';

class ClimateResults extends StatefulWidget {
  WeatherDataModel currentWeather;
  ClimateResults({required this.currentWeather});

  @override
  State<ClimateResults> createState() => _ClimateResultsState();
}

class _ClimateResultsState extends State<ClimateResults> {
  final TextEditingController locationSearchField = TextEditingController();
  WeatherDataCurrent? weatherDataCurrent;

  String date = DateFormat.yMMMMd().format(DateTime.now());

  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderWidget(currentWeather: widget.currentWeather),
              CurrentWeatherWidget(
                currentWeather: widget.currentWeather,
              ),
              SizedBox(
                height: 20,
              ),
              HourlyDetails(currentWeather: widget.currentWeather)
            ],
          ),
        ),
      ),
    );
  }
}
