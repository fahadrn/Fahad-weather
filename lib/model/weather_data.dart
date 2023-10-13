import 'package:weather/model/weather_data_current.dart';

class WeatherData {
  final WeatherDataCurrent? current;
  WeatherData([
    this.current,
  ]);

  WeatherDataCurrent getCurrentWeather() => current!;
}
