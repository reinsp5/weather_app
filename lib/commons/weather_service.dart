import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _domain = "api.open-meteo.com";

  Future<WeekWeather> getWeekWeather(latitude, longitude) async {
    Map<String, dynamic> _parms = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "timezone": "Asia/Tokyo"
    };
    Uri _uri = Uri.https(_domain, '/v1/forecast', _parms);
    http.Response _response = await http.get(Uri.parse(_uri.toString()));
    return WeekWeather.fromJson(jsonDecode(_response.body));
  }
}

class WeekWeather {
  WeekWeather({
    required this.dailyUnits,
    required this.latitude,
    required this.elevation,
    required this.utcOffsetSeconds,
    required this.generationtimeMs,
    required this.longitude,
    required this.daily,
  });

  DailyUnits dailyUnits;
  double latitude;
  double elevation;
  int utcOffsetSeconds;
  double generationtimeMs;
  double longitude;
  Daily daily;

  factory WeekWeather.fromJson(Map<String, dynamic> json) => WeekWeather(
        dailyUnits: DailyUnits.fromJson(json["daily_units"]),
        latitude: json["latitude"].toDouble(),
        elevation: json["elevation"].toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        generationtimeMs: json["generationtime_ms"].toDouble(),
        longitude: json["longitude"].toDouble(),
        daily: Daily.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
        "daily_units": dailyUnits.toJson(),
        "latitude": latitude,
        "elevation": elevation,
        "utc_offset_seconds": utcOffsetSeconds,
        "generationtime_ms": generationtimeMs,
        "longitude": longitude,
        "daily": daily.toJson(),
      };
}

class Daily {
  Daily({
    required this.sunset,
    required this.sunrise,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.time,
    required this.weathercode,
  });

  List<String> sunset;
  List<String> sunrise;
  List<double> temperature2MMax;
  List<double> temperature2MMin;
  List<DateTime> time;
  List<int> weathercode;

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        sunset: List<String>.from(json["sunset"].map((x) => x)),
        sunrise: List<String>.from(json["sunrise"].map((x) => x)),
        temperature2MMax: List<double>.from(
            json["temperature_2m_max"].map((x) => x.toDouble())),
        temperature2MMin: List<double>.from(
            json["temperature_2m_min"].map((x) => x.toDouble())),
        time: List<DateTime>.from(json["time"].map((x) => DateTime.parse(x))),
        weathercode: List<int>.from(json["weathercode"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "sunset": List<dynamic>.from(sunset.map((x) => x)),
        "sunrise": List<dynamic>.from(sunrise.map((x) => x)),
        "temperature_2m_max":
            List<dynamic>.from(temperature2MMax.map((x) => x)),
        "temperature_2m_min":
            List<dynamic>.from(temperature2MMin.map((x) => x)),
        "time": List<dynamic>.from(time.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "weathercode": List<dynamic>.from(weathercode.map((x) => x)),
      };
}

class DailyUnits {
  DailyUnits({
    required this.sunset,
    required this.sunrise,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.time,
    required this.weathercode,
  });

  String sunset;
  String sunrise;
  String temperature2MMax;
  String temperature2MMin;
  String time;
  String weathercode;

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
        sunset: json["sunset"],
        sunrise: json["sunrise"],
        temperature2MMax: json["temperature_2m_max"],
        temperature2MMin: json["temperature_2m_min"],
        time: json["time"],
        weathercode: json["weathercode"],
      );

  Map<String, dynamic> toJson() => {
        "sunset": sunset,
        "sunrise": sunrise,
        "temperature_2m_max": temperature2MMax,
        "temperature_2m_min": temperature2MMin,
        "time": time,
        "weathercode": weathercode,
      };
}
