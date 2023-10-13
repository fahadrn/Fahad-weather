import 'package:flutter/material.dart';
import 'package:weather/model/WeatherDataModel.dart';
import 'package:weather/widgets/Detailed_hours_widget.dart';

class HourlyDetails extends StatefulWidget {
  final WeatherDataModel currentWeather;

  const HourlyDetails({
    required this.currentWeather,
  });

  @override
  State<HourlyDetails> createState() => _HourlyDetailsState();
}

class _HourlyDetailsState extends State<HourlyDetails> {
  late WeatherDataModel currentWeather;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.tryParse('256'),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 102, 194, 227),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 35, left: 10),
                child: Text(
                  'The Next hours',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0;
                    i <
                        widget
                            .currentWeather.forecast.forecastday[0].hour.length;
                    i++)
                  DetailedHours(
                      hour:
                          "${widget.currentWeather.forecast.forecastday[0].hour[i].time}",
                      temperature:
                          "${widget.currentWeather.forecast.forecastday[0].hour[i].tempC.round()}",
                      imageURL:
                          'http:${widget.currentWeather.forecast.forecastday[0].hour[i].condition.icon.toString()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
