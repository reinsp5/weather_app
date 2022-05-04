import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/commons/location_service.dart';
import 'package:weather_app/commons/weather_service.dart';

class HomeProvider with ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;
  LocationService locationService = LocationService();
  WeatherService weatherService = WeatherService();

  List<int> _weatherCode = [];

  double get latitude => _latitude;
  double get longitude => _longitude;
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
