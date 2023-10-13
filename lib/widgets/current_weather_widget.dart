import 'package:flutter/material.dart';
import 'package:weather/model/WeatherDataModel.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherDataModel currentWeather;
  const CurrentWeatherWidget({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        temperatureAreaWidget(),
        SizedBox(
          height: 20,
        ),
        currentWeatherMoreWidget(),
      ],
    );
  }

  Widget temperatureAreaWidget() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'http:${currentWeather.current.condition.icon.toString()}',
            width: 50,
            height: 50,
          ),
          Text(
            '${currentWeather.current.tempC.toInt()}°C',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget currentWeatherMoreWidget() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Wind status',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${currentWeather.current.windKph.round()} kmph',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Humidity',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${currentWeather.current.humidity.round()} %',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Visibility',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${currentWeather.current.visKm.round()} miles',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Air Pressure',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${currentWeather.current.pressureIn.round()} mb',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
