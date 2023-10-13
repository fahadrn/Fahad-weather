import 'dart:convert';

import 'package:weather/api/api_key.dart';
import 'package:weather/model/weather_data.dart';
import 'package:http/http.dart' as http;
import 'package:weather/model/weather_data_current.dart';

class FetchWeatherSearch {
  WeatherData? weatherData;

  Future<WeatherData> processData(lat, lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonstring = jsonDecode(response.body);
    weatherData = WeatherData(WeatherDataCurrent.fromJson(jsonstring));

    return weatherData!;
  }

  Future<WeatherData> location(lat, lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonstring = jsonDecode(response.body);
    weatherData = WeatherData(WeatherDataCurrent.fromJson(jsonstring));

    return weatherData!;
  }
}

String apiURL(var lat, var lon) {
  String url;

  url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$lat,$lon";
  return url;
}
