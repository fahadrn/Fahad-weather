import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/api/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:weather/controller/global_controller.dart';
import 'package:weather/model/WeatherDataModel.dart';
import 'package:weather/screens/favorite_details_screen.dart';
import 'package:weather/ui_elements/blueGradient.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late WeatherDataModel currentWeather;
  List<String> favoriteLocations = [];

  String capitalFirstLetter(String string) {
    return string[0].toUpperCase() + string.substring(1);
  }

  void deleteAlert(location) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(148, 0, 229, 255),
            title: Text(
              'Delete Confirmation',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              ' Delete $location from Favorites ?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  deleteFavorite(location);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void deleteFavorite(location) async {
    setState(() {
      favoriteLocations.remove(location);
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('favoriteLocations', favoriteLocations);
  }

  Future<void> fetchFavoriteDeatils() async {
    setState(() {});

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {});
    String url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$favoriteLocations";
    var response = await http.get(Uri.parse(url));
    WeatherDataModel data = WeatherDataModel.fromRawJson(response.body);
    setState(() {
      currentWeather = data;
    });
  }

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  void initState() {
    getFavoriteLocations();
    super.initState();
  }

  Future<void> getFavoriteLocations() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      favoriteLocations =
          sharedPreferences.getStringList('favoriteLocations') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
        backgroundColor: Color.fromARGB(255, 4, 160, 160),
      ),
      body: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: blueGradient),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteLocations.length,
                    itemBuilder: (context, index) {
                      String capitalLocation =
                          capitalFirstLetter(favoriteLocations[index]);
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          capitalLocation,
                          // favoriteLocations[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        selectedTileColor: Colors.white,
                        // subtitle: Text('${}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            deleteAlert(favoriteLocations[index]);
                            // deleteFavorite(favoriteLocations[index]);
                          },
                        ),
                        //  Icon(
                        //   Icons.chevron_right,
                        //   color: Colors.white,
                        // ),
                        onTap: () {
                          navigator?.push(MaterialPageRoute(
                              builder: (context) => FavoriteDetailsScreen(
                                    location: favoriteLocations[index],
                                  )));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
