// ignore_for_file: unused_element

class WeatherDataCurrent {
  final Current current;
  WeatherDataCurrent({required this.current});

  factory WeatherDataCurrent.fromJson(Map<String, dynamic> json) =>
      WeatherDataCurrent(current: Current.fromJson(json['current']));
}

class Current {
  int? tempC;
  Condition? condition;
  double? windKph;
  int? humidity;
  int? cloud;

  Current({
    this.tempC,
    this.condition,
    this.windKph,
    this.humidity,
    this.cloud,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        tempC: (json['temp_c'] as num?)?.round(),
        condition: json['condition'] == null
            ? null
            : Condition.fromJson(json['condition'] as Map<String, dynamic>),
        windKph: (json['wind_kph'] as num?)?.toDouble(),
        humidity: json['humidity'] as int?,
        cloud: json['cloud'] as int?,
      );
}

Map<String, dynamic> toJson(Current instance) => <String, dynamic>{
      'temp_c': instance.tempC,
      'condition': instance.condition,
      'wind_kph': instance.windKph,
      'humidity': instance.humidity,
      'cloud': instance.cloud,
    };

class Condition {
  String? text;
  String? icon;
  int? code;

  Condition({this.text, this.icon, this.code});

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        text: json['text'] as String?,
        icon: json['icon'] as String?,
        code: json['code'] as int?,
      );
}

Map<String, dynamic> ToJson(Condition instance) => <String, dynamic>{
      'text': instance.text,
      'icon': instance.icon,
      'code': instance.code,
    };
