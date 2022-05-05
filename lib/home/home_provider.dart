import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/commons/location_service.dart';
import 'package:weather_app/commons/weather_service.dart';

class HomeProvider with ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _prefecture = "";
  String _city = "";
  LocationService locationService = LocationService();
  WeatherService weatherService = WeatherService();

  List<int> _weatherCode = [];

  double get latitude => _latitude;
  double get longitude => _longitude;
  String get prefecture => _prefecture;
  String get city => _city;
  List<int> get weatherCode => _weatherCode;

  set latitude(latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  set longitude(longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  /// GPSの位置情報を取得する
  Future<void> getLocation() async {
    LocationData _locationData = await locationService.getGpsPosition();
    Map<String, dynamic> result = await locationService.getLocationName(
        latitude: _locationData.latitude!, longitude: _locationData.longitude!);
    MyLocationData _locationName = MyLocationData.fromJson(result["response"]);
    _prefecture = _locationName.location.first.prefecture;
    _city = _locationName.location.first.city;
    _latitude = _locationData.latitude!;
    _longitude = _locationData.longitude!;
    notifyListeners();
  }

  /// 一週間先までの天気予報を取得する
  Future<void> getWeekWeather() async {
    WeekWeather _weekWeather = WeekWeather.fromJson(
        await weatherService.getWeekWeather(_latitude, _longitude));
    _weatherCode = _weekWeather.daily.weathercode;
    notifyListeners();
  }
}

class WeekWeather {
  WeekWeather({
    required this.generationtimeMs,
    required this.longitude,
    required this.dailyUnits,
    required this.elevation,
    required this.latitude,
    required this.utcOffsetSeconds,
    required this.daily,
  });

  double generationtimeMs = 0.0;
  double longitude = 0.0;
  DailyUnits dailyUnits;
  double elevation = 0.0;
  double latitude = 0.0;
  int utcOffsetSeconds = 0;
  Daily daily;

  factory WeekWeather.fromJson(Map<String, dynamic> json) => WeekWeather(
        generationtimeMs: json["generationtime_ms"].toDouble(),
        longitude: json["longitude"].toDouble(),
        dailyUnits: DailyUnits.fromJson(json["daily_units"]),
        elevation: json["elevation"].toDouble(),
        latitude: json["latitude"].toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        daily: Daily.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
        "generationtime_ms": generationtimeMs,
        "longitude": longitude,
        "daily_units": dailyUnits.toJson(),
        "elevation": elevation,
        "latitude": latitude,
        "utc_offset_seconds": utcOffsetSeconds,
        "daily": daily.toJson(),
      };
}

class Daily {
  Daily({
    required this.sunset,
    required this.sunrise,
    required this.temperature2MMin,
    required this.temperature2MMax,
    required this.time,
    required this.weathercode,
  });

  List<String> sunset = [];
  List<String> sunrise = [];
  List<double> temperature2MMin = [];
  List<double> temperature2MMax = [];
  List<DateTime> time = [];
  List<int> weathercode = [];

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        sunset: List<String>.from(json["sunset"].map((x) => x)),
        sunrise: List<String>.from(json["sunrise"].map((x) => x)),
        temperature2MMin: List<double>.from(
            json["temperature_2m_min"].map((x) => x.toDouble())),
        temperature2MMax: List<double>.from(
            json["temperature_2m_max"].map((x) => x.toDouble())),
        time: List<DateTime>.from(json["time"].map((x) => DateTime.parse(x))),
        weathercode: List<int>.from(json["weathercode"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "sunset": List<dynamic>.from(sunset.map((x) => x)),
        "sunrise": List<dynamic>.from(sunrise.map((x) => x)),
        "temperature_2m_min":
            List<dynamic>.from(temperature2MMin.map((x) => x)),
        "temperature_2m_max":
            List<dynamic>.from(temperature2MMax.map((x) => x)),
        "time": List<dynamic>.from(time.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "weathercode": List<dynamic>.from(weathercode.map((x) => x)),
      };
}

class DailyUnits {
  DailyUnits({
    required this.sunset,
    required this.sunrise,
    required this.temperature2MMin,
    required this.temperature2MMax,
    required this.time,
    required this.weathercode,
  });

  String sunset = "";
  String sunrise = "";
  String temperature2MMin = "";
  String temperature2MMax = "";
  String time = "";
  String weathercode = "";

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
        sunset: json["sunset"],
        sunrise: json["sunrise"],
        temperature2MMin: json["temperature_2m_min"],
        temperature2MMax: json["temperature_2m_max"],
        time: json["time"],
        weathercode: json["weathercode"],
      );

  Map<String, dynamic> toJson() => {
        "sunset": sunset,
        "sunrise": sunrise,
        "temperature_2m_min": temperature2MMin,
        "temperature_2m_max": temperature2MMax,
        "time": time,
        "weathercode": weathercode,
      };
}

class MyLocationData {
  MyLocationData({
    required this.location,
  });

  List<MyLocation> location;

  factory MyLocationData.fromJson(Map<String, dynamic> json) => MyLocationData(
        location: List<MyLocation>.from(
            json["location"].map((x) => MyLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "location": List<dynamic>.from(location.map((x) => x.toJson())),
      };
}

class MyLocation {
  MyLocation({
    this.prefecture = "",
    this.city = "",
    this.cityKana = "",
    this.town = "",
    this.townKana = "",
  });

  String prefecture;
  String city;
  String cityKana;
  String town;
  String townKana;

  factory MyLocation.fromJson(Map<String, dynamic> json) => MyLocation(
        city: json["city"],
        cityKana: json["city_kana"],
        town: json["town"],
        townKana: json["town_kana"],
        prefecture: json["prefecture"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "city_kana": cityKana,
        "town": town,
        "town_kana": townKana,
        "prefecture": prefecture,
      };
}
