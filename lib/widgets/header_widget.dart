// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/controller/global_controller.dart';
import 'package:weather/model/WeatherDataModel.dart';
import 'package:weather/screens/favorites_screen.dart';
import 'package:weather/screens/search_screen.dart';

class HeaderWidget extends StatefulWidget {
  WeatherDataModel currentWeather;
  bool isHome;
  bool isExpanded = false;
  HeaderWidget({super.key, required this.currentWeather, this.isHome = false});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String city = "";
  String date = DateFormat.yMMMMd().format(DateTime.now());
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  void initState() {
    getAddress(globalController.getLatitude().value,
        globalController.getLongitude().value);
    super.initState();
  }

  getAddress(lat, lon) async {
    setState(() {
      city = widget.currentWeather.location.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (widget.isHome)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    onPressed: () {
                      navigator?.push(MaterialPageRoute(
                          builder: (context) => FavoritesScreen()));
                    },
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 40,
                    )),
                IconButton(
                  padding: EdgeInsets.only(right: 15, top: 15),
                  icon: Icon(Icons.search, color: Colors.white, size: 45),
                  onPressed: () {
                    navigator?.push(MaterialPageRoute(
                        builder: (context) => SearchScreen()));
                  },
                ),
              ],
            ),
          Text(
            'Today,$date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          Text(
            '${widget.currentWeather.location.name}',
            style: TextStyle(
                fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${widget.currentWeather.location.region} , ${widget.currentWeather.location.country}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
