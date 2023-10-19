// ignore_for_file: must_be_immutable

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/api/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/model/WeatherDataModel.dart';
import 'package:weather/model/climate_results.dart';
import 'package:weather/model/weather_data_current.dart';
import 'package:weather/screens/favorites_screen.dart';
import 'package:weather/ui_elements/blueGradient.dart';
import 'package:weather/widgets/scroller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController locationSearchField = TextEditingController();
  WeatherDataCurrent? weatherDataCurrent;

  List<String> favoriteLocations = [];

  bool isLocationInFavorites(String location) {
    return favoriteLocations.contains(location);
  }

  Future<void> addToFavorites() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    List<String> favourites = [];
    favourites = sharedPreferences.getStringList('favoriteLocations') ?? [];
    favourites.add(locationSearchField.text);

    sharedPreferences
        .setStringList('favoriteLocations', favourites)
        .then((value) {
      setState(() {
        favoriteLocations = favourites;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.white,
            duration: Duration(seconds: 1),
            content: Text(
              "Added to Favorites",
              style: TextStyle(color: Color.fromARGB(255, 14, 89, 119)),
            )),
      );
    });
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

  late WeatherDataModel currentWeather;
  bool isLoaded = false;
  bool isLoading = false;

  // List<String> previousSearchedLocations = [];
  // SharedPreferences? previouslocations;

  Future<void> fetchLocationClimateDetails() async {
    setState(() {
      isLoading = true;
    });
    final location = locationSearchField.text;
    String url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$location";

    WeatherDataModel data;
    await http.get(Uri.parse(url)).then((value) async {
      data = WeatherDataModel.fromRawJson(value.body);

      final sharedPreferences = await SharedPreferences.getInstance();
      List<String> favorites =
          sharedPreferences.getStringList('favoriteLocations') ?? [];

      setState(() {
        favoriteLocations = favorites;
      });

      setState(() {
        currentWeather = data;
        isLoaded = true;
        isLoading = false;
      });
    }).onError(
      (error, stackTrace) {
        print(error);
        setState(() {
          isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(148, 0, 229, 255),
              title: Text(
                'Alert',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Location Not Found',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (isLoaded)
              IconButton(
                tooltip: 'Favorites',
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  navigator?.push(MaterialPageRoute(
                      builder: (context) => FavoritesScreen()));
                },
              ),
          ],
          title: Text('Search', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 4, 160, 160),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: blueGradient,
          ),
          padding: const EdgeInsets.all(2),
          child: MediaQuery.of(context).size.height < 782
              ? Scroller(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: locationSearchField,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            left: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Enter Location',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            onPressed: fetchLocationClimateDetails,
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (Value) =>
                            fetchLocationClimateDetails(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (isLoading)
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.blue,
                        ),
                      if (isLoaded && !isLoading)
                        ClimateResults(
                          currentWeather: currentWeather,
                        ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: locationSearchField,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        hintText: 'Enter Location',
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: fetchLocationClimateDetails,
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (Value) =>
                          fetchLocationClimateDetails(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (isLoading)
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.blue,
                      ),
                    if (isLoaded && !isLoading)
                      ClimateResults(
                        currentWeather: currentWeather,
                      ),
                  ],
                ),
        ),
        floatingActionButton: !isLoaded
            ? null
            : FloatingActionButton.extended(
                key: ValueKey('favorite_button'),
                icon: isLocationInFavorites(locationSearchField.text)
                    ? Icon(Icons.remove)
                    : Icon(Icons.add),
                tooltip: isLocationInFavorites(locationSearchField.text)
                    ? 'Remove location from favorites'
                    : 'Add location to favorites',
                heroTag: 'favorite_button',
                backgroundColor: Color.fromARGB(255, 4, 160, 160),
                onPressed: () {
                  if (isLocationInFavorites(locationSearchField.text)) {
                    removeFromFavorite();
                  } else {
                    addToFavorites();
                  }

                  setState(() {});
                },
                label: Text(isLocationInFavorites(locationSearchField.text)
                    ? 'Remove from Favorites'
                    : 'Add To Favorites'),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: Color.fromARGB(255, 14, 89, 119),
      ),
    );
  }
}
