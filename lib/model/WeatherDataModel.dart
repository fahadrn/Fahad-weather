import 'dart:convert';

class WeatherDataModel {
  Location location;
  Current current;
  Forecast forecast;

  WeatherDataModel({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherDataModel.fromRawJson(String str) =>
      WeatherDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) =>
      WeatherDataModel(
        location: Location.fromJson(json["location"]),
        current: Current.fromJson(json["current"]),
        forecast: Forecast.fromJson(json["forecast"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "current": current.toJson(),
        "forecast": forecast.toJson(),
      };
}

class Current {
  double tempC;
  double tempF;
  Condition condition;
  double windKph;
  String windDir;
  double pressureIn;
  double humidity;
  double cloud;
  double feelslikeC;
  double feelslikeF;
  double visKm;
  double visMiles;

  Current({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windKph,
    required this.windDir,
    required this.pressureIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.visMiles,
  });

  factory Current.fromRawJson(String str) => Current.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        tempC: json["temp_c"],
        tempF: json["temp_f"]?.toDouble(),
        condition: Condition.fromJson(json["condition"]),
        windKph: json["wind_kph"]?.toDouble(),
        windDir: json["wind_dir"],
        pressureIn: json["pressure_in"]?.toDouble(),
        humidity: (json['humidity'] as num?)!.toDouble(),
        cloud: (json['cloud'] as num?)!.toDouble(),
        feelslikeC: json["feelslike_c"]?.toDouble(),
        feelslikeF: json["feelslike_f"],
        visKm: json["vis_km"],
        visMiles: json["vis_miles"],
      );

  Map<String, dynamic> toJson() => {
        "temp_c": tempC,
        "temp_f": tempF,
        "condition": condition.toJson(),
        "wind_kph": windKph,
        "wind_dir": windDir,
        "pressure_in": pressureIn,
        "humidity": humidity,
        "cloud": cloud,
        "feelslike_c": feelslikeC,
        "feelslike_f": feelslikeF,
        "vis_km": visKm,
        "vis_miles": visMiles,
      };
}

class Condition {
  String text;
  String icon;
  int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromRawJson(String str) =>
      Condition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        text: json["text"],
        icon: json["icon"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "icon": icon,
        "code": code,
      };
}

class Forecast {
  List<Forecastday> forecastday;

  Forecast({
    required this.forecastday,
  });

  factory Forecast.fromRawJson(String str) =>
      Forecast.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
        forecastday: List<Forecastday>.from(
            json["forecastday"].map((x) => Forecastday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "forecastday": List<dynamic>.from(forecastday.map((x) => x.toJson())),
      };
}

class Forecastday {
  DateTime date;
  int dateEpoch;
  List<Hour> hour;

  Forecastday({
    required this.date,
    required this.dateEpoch,
    required this.hour,
  });

  factory Forecastday.fromRawJson(String str) =>
      Forecastday.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
        date: DateTime.parse(json["date"]),
        dateEpoch: json["date_epoch"],
        hour: List<Hour>.from(json["hour"].map((x) => Hour.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "date_epoch": dateEpoch,
        "hour": List<dynamic>.from(hour.map((x) => x.toJson())),
      };
}

class Hour {
  String time;
  double tempC;
  double tempF;
  Condition condition;
  double windKph;
  String windDir;
  double pressureIn;
  int humidity;
  int cloud;

  Hour({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windKph,
    required this.windDir,
    required this.pressureIn,
    required this.humidity,
    required this.cloud,
  });

  factory Hour.fromRawJson(String str) => Hour.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
        time: json["time"],
        tempC: json["temp_c"]?.toDouble(),
        tempF: json["temp_f"]?.toDouble(),
        condition: Condition.fromJson(json["condition"]),
        windKph: json["wind_kph"]?.toDouble(),
        windDir: json["wind_dir"],
        pressureIn: json["pressure_in"]?.toDouble(),
        humidity: json["humidity"],
        cloud: json["cloud"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "temp_c": tempC,
        "temp_f": tempF,
        "condition": condition.toJson(),
        "wind_kph": windKph,
        "wind_dir": windDir,
        "pressure_in": pressureIn,
        "humidity": humidity,
        "cloud": cloud,
      };
}

class Location {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  int localtimeEpoch;
  String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        tzId: json["tz_id"],
        localtimeEpoch: json["localtime_epoch"],
        localtime: json["localtime"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "region": region,
        "country": country,
        "lat": lat,
        "lon": lon,
        "tz_id": tzId,
        "localtime_epoch": localtimeEpoch,
        "localtime": localtime,
      };
}
