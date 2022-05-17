import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/utils/location_service.dart';
import 'package:weather_app/utils/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeViewModel extends ChangeNotifier {
  // 画面描画に必要な情報
  String _state = ""; // 都道府県
  String _city = ""; // 市区町村
  IconData _weatherIcon = WeatherIcons.na; // 天候アイコン
  Color _weatherIconColor = Colors.white;
  String _weatherText = ""; // 天候
  String _temperature2MMin = "  . "; // 最低気温
  String _temperature2MMax = "  . "; // 最高気温
  String _sunrise = "  :  "; // 日の出
  String _sunset = "  :  "; // 日の入
  bool _isLoading = true; // ローディング画面 ＯＮ／ＯＦＦ
  final String _dateTime = DateFormat("yyyy年MM月dd日").format(DateTime.now());

  double _latitude = 0.0;
  double _longitude = 0.0;

  LocationService locationService = LocationService();
  WeatherService weatherService = WeatherService();

  Daily _daily = Daily();

  String get state => _state;
  String get city => _city;
  IconData get weatherIcon => _weatherIcon;
  Color get weatherIconColor => _weatherIconColor;
  String get weatherText => _weatherText;
  String get temperature2MMin => _temperature2MMin;
  String get temperature2MMax => _temperature2MMax;
  String get sunrise => _sunrise;
  String get sunset => _sunset;
  bool get isLoading => _isLoading;
  String get dateTime => _dateTime;

  /// 現在位置を取得し、保管する。
  Future<void> getLocAsGps() async {
    // 位置情報を取得取得する
    Position _position = await locationService.getCurrentPosition();

    // 位置情報を基に地名を取得する
    Placemark _placemark =
        await locationService.getCurrentPositionName(position: _position);
    setLocationInfo(position: _position, placemark: _placemark);
    getWeekWeather();
    notifyListeners();
  }

  /// 現在位置を保存する
  void setLocationInfo(
      {required Position position, required Placemark placemark}) {
    // 緯度／経度を保管する
    _latitude = position.latitude;
    _longitude = position.longitude;
    // 画面の描画に必要なデータを取り出し、保管する
    _state = placemark.administrativeArea ?? "";
    _city = placemark.locality ?? "";
  }

  /// 一週間先までの天気予報を取得する
  Future<void> getWeekWeather() async {
    WeekWeather _weekWeather = WeekWeather.fromJson(
        await weatherService.getWeeklyWeather(_latitude, _longitude));
    _daily = _weekWeather.daily;
    setWeatherInfo(weatherInfo: _daily);
    _temperature2MMin = _daily.temperature2MMin.first.toString();
    _temperature2MMax = _daily.temperature2MMax.first.toString();
    DateTime dateTime = DateTime.parse(_daily.sunrise.first);
    _sunrise = dateTime.hour.toString().padLeft(2, "0") +
        ":" +
        dateTime.minute.toString().padLeft(2, "0");

    dateTime = DateTime.parse(_daily.sunset.first);
    _sunset = dateTime.hour.toString().padLeft(2, "0") +
        ":" +
        dateTime.minute.toString().padLeft(2, "0");
    _isLoading = false;
    notifyListeners();
  }

  void streamLocation() async {
    LocationSettings settings = const LocationSettings(distanceFilter: 500);

    // ignore: unused_local_variable
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: settings)
            .listen((Position? position) async {
      if (position != null) {
        Placemark placemark =
            await locationService.getCurrentPositionName(position: position);
        setLocationInfo(position: position, placemark: placemark);
        getWeekWeather();
        notifyListeners();
      }
    });
  }

  /// 天候，天候アイコンをセットする
  void setWeatherInfo({required Daily weatherInfo}) {
    switch (weatherInfo.weathercode.first) {
      case 0:
        _weatherIcon = WeatherIcons.day_sunny;
        _weatherIconColor = Colors.orange;
        _weatherText = "快晴";
        break;
      case 1:
        _weatherIcon = WeatherIcons.day_sunny;
        _weatherIconColor = Colors.orange;
        _weatherText = "晴れ";
        break;
      case 2:
        _weatherIcon = WeatherIcons.day_sunny_overcast;
        _weatherIconColor = Colors.grey;
        _weatherText = "晴れ時々曇り";
        break;
      case 3:
        _weatherIcon = WeatherIcons.cloudy;
        _weatherIconColor = Colors.grey;
        _weatherText = "くもり";
        break;
      case 45:
        _weatherIcon = WeatherIcons.day_fog;
        _weatherIconColor = Colors.grey;
        _weatherText = "霧";
        break;
      case 48:
        _weatherIcon = WeatherIcons.fog;
        _weatherIconColor = Colors.grey;
        _weatherText = "濃霧";
        break;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        _weatherIcon = WeatherIcons.day_showers;
        _weatherIconColor = Colors.blue;
        _weatherText = "霧雨";
        break;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        _weatherIcon = WeatherIcons.rain;
        _weatherIconColor = Colors.blue;
        _weatherText = "雨";
        break;
      case 71:
      case 73:
      case 75:
      case 77:
        _weatherIcon = WeatherIcons.snow;
        _weatherIconColor = Colors.white;
        _weatherText = "雪";
        break;
      case 80:
      case 81:
      case 82:
        _weatherIcon = WeatherIcons.day_rain;
        _weatherIconColor = Colors.blue;
        _weatherText = "にわか雨";
        break;
      case 85:
      case 86:
        _weatherIcon = WeatherIcons.day_rain_mix;
        _weatherIconColor = Colors.white;
        _weatherText = "みぞれ雪";
        break;
      default:
        _weatherIcon = WeatherIcons.na;
        _weatherIconColor = Colors.white;
        _weatherText = "不明";
    }
  }
}
