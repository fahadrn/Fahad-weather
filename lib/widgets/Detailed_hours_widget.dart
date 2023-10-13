import 'package:flutter/material.dart';
import 'package:weather/model/WeatherDataModel.dart';

class DetailedHours extends StatefulWidget {
  final String hour;
  final String imageURL;
  final String temperature;
  const DetailedHours({
    super.key,
    required this.hour,
    required this.imageURL,
    required this.temperature,
  });

  @override
  State<DetailedHours> createState() => _DetailedHoursState();
}

class _DetailedHoursState extends State<DetailedHours> {
  late WeatherDataModel currentWeather;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            widget.hour.split(' ')[1],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(width: 1, color: Colors.grey)),
            // elevation: Checkbox.width,
            // shadowColor: Color.fromARGB(255, 9, 177, 228),
            child: Column(
              children: [
                Image.network(
                  '${widget.imageURL}',
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 5,
                ),
                Text('${widget.temperature}°C',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
