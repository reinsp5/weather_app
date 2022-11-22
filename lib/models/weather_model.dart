import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:weather/weather.dart';

class MyWeather extends Weather {
  MyWeather(Map<String, dynamic> jsonData) : super(jsonData);
  Icon? weatherIconData;
  String? weatherText;
  WeatherType? weatherType;
  String? sunriseText;
  String? sunsetText;
}
