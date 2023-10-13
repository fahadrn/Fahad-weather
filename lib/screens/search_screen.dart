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
      // if (favorites.contains(locationSearchField.text)) {
      //   print('available');
      //   setState(() {
      //     isavailable = true;
      //   });
      // } else {
      //   setState(() {
      //     isavailable = false;
      //   });
      // }

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
              // icon: Icon(Icons.dangerous),
              backgroundColor: Colors.white,
              title: Text('Alert'),
              content: Text('Location not found'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: Colors.blue)),
                ),
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
          title: Text('Search', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 14, 89, 119),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: blueGradient,
          ),
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
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

                    // prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: fetchLocationClimateDetails,
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (Value) => fetchLocationClimateDetails(),
                  // onChanged: (value) => fetchLocationClimateDetails(),
                ),
                SizedBox(height: 10),
                if (isLoading)
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.blue,
                  ),
                if (isLoaded && !isLoading)
                  ClimateResults(
                    currentWeather: currentWeather,
                  ),
                if (isLoaded)
                  ElevatedButton(
                    onPressed: () {
                      if (isLocationInFavorites(locationSearchField.text)) {
                        removeFromFavorite();
                      } else {
                        addToFavorites();
                      }

                      setState(() {});
                    },
                    child: Text(isLocationInFavorites(locationSearchField.text)
                        ? 'Remove from Favorites'
                        : 'Add to Favorites'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 4, 111, 153),
                    ),
                  ),
                if (isLoaded)
                  ElevatedButton(
                    onPressed: () {
                      navigator?.push(MaterialPageRoute(
                          builder: (context) => FavoritesScreen()));
                    },
                    child: Text("Go to Favorites"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 4, 111, 153),
                    ),
                  ),
                // ListView.builder(
                //   itemCount: previousSearchedLocations.length,
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) {
                //     return ElevatedButton(
                //       child: Text(previousSearchedLocations[index]),
                //       onPressed: () {},
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 14, 89, 119),
      ),
    );
  }
}
