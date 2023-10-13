import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/api/fetch_weather.dart';
import 'package:weather/model/weather_data.dart';

class GlobalController extends GetxController {
  RxBool _isLoading = true.obs;
  RxDouble _latitude = 0.0.obs;
  RxDouble _longitude = 0.0.obs;

  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  WeatherData getWeatherData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error("location not enabled");
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("location permission denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("location permission is denied");
      }
    }
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      // _isLoading.value = false;
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;

      return FetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
        // print(_latitude);
        // print(_longitude);
        // print(apikey);
        // print(weatherData);
        // print(apiURL);
      });
    });
  }
}
