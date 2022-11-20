import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/utils/location_service.dart';
import 'package:weather_app/utils/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeViewModel extends ChangeNotifier {
  // 画面描画に必要な情報
  late Weather _weather;
  late List<Weather> _weeklyWeather;
  late Icon _weatherIcon; // 天候アイコン
  String _state = ""; // 都道府県
  String _city = ""; // 市区町村
  String _weatherText = ""; // 天候
  String _temperature2MMin = "  . "; // 最低気温
  String _temperature2MMax = "  . "; // 最高気温
  String _sunrise = "  :  "; // 日の出
  String _sunset = "  :  "; // 日の入
  bool _isLoading = true; // ローディング画面 ＯＮ／ＯＦＦ

  double _latitude = 0.0;
  double _longitude = 0.0;

  WeatherType _weatherType = WeatherType.sunny;

  LocationService locationService = LocationService();
  WeatherService weatherService = WeatherService();

  Weather get weather => _weather;
  List<Weather> get weeklyWeather => _weeklyWeather;
  String get state => _state;
  String get city => _city;
  Icon get weatherIcon => _weatherIcon;
  // List<Color> get weatherIconColor => _weatherIconColor;
  String get weatherText => _weatherText;
  String get temperature2MMin => _temperature2MMin;
  String get temperature2MMax => _temperature2MMax;
  String get sunrise => _sunrise;
  String get sunset => _sunset;
  bool get isLoading => _isLoading;
  WeatherType get weatherType => _weatherType;

  /// 現在位置を取得し、保管する。
  Future<void> getLocAsGps() async {
    // 位置情報を取得取得する
    Position _position = await locationService.getCurrentPosition();

    // 位置情報を基に地名を取得する
    Placemark _placemark =
        await locationService.getCurrentPositionName(position: _position);
    setLocationInfo(position: _position, placemark: _placemark);

    await setCurrentWeather();
    streamLocation();
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

  /// 現在地の天気取得
  Future<void> setCurrentWeather() async {
    _weather = await weatherService.getCurrentWeatherByLocation(
      lat: _latitude,
      lon: _longitude,
    );
    _weeklyWeather = await weatherService.getWeeklyWeather(
      lat: _latitude,
      lon: _longitude,
    );
    setWeatherInfo(
      weathercode: _weather.weatherConditionCode!,
    );
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
        await setCurrentWeather();
      }
    });
  }

  /// 天候，天候アイコンをセットする
  void setWeatherInfo({required int weathercode}) {
    switch (weathercode) {
      // OpenWeatherAPI
      // 雷雨
      case 200:
      case 201:
      case 202:
      case 210:
      case 211:
      case 212:
      case 221:
      case 230:
      case 231:
      case 232:
        _weatherIcon = Icon(
          WeatherIcons.thunderstorm,
          color: NordColors.aurora.yellow,
        );
        _weatherText = "雷雨";
        _weatherType = WeatherType.thunder;
        break;
      // 霧雨
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
        _weatherIcon = Icon(
          WeatherIcons.day_showers,
          color: NordColors.frost.darkest,
        );
        _weatherText = "霧雨";
        _weatherType = WeatherType.lightRainy;
        break;
      // 雨
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      case 511:
      case 520:
      case 521:
      case 522:
      case 531:
        _weatherIcon = Icon(
          WeatherIcons.rain,
          size: 150.0,
          color: NordColors.frost.darkest,
        );
        _weatherText = "雨";
        _weatherType = WeatherType.middleRainy;
        break;
      // 雪
      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        _weatherIcon = Icon(
          WeatherIcons.snow,
          color: NordColors.snowStorm.lightest,
        );
        _weatherText = "雪";
        _weatherType = WeatherType.middleSnow;
        break;
      // 霞
      case 701:
        _weatherIcon = Icon(
          WeatherIcons.snow,
          color: NordColors.snowStorm.medium,
        );
        _weatherText = "霞";
        _weatherType = WeatherType.hazy;
        break;
      // 霧
      case 741:
        _weatherIcon = Icon(
          WeatherIcons.day_fog,
          color: NordColors.snowStorm.medium,
        );
        _weatherText = "霧";
        _weatherType = WeatherType.foggy;
        break;
      case 800:
        _weatherIcon = Icon(
          WeatherIcons.day_sunny,
          color: NordColors.aurora.orange,
        );
        _weatherText = "晴れ";
        _weatherType = WeatherType.sunny;
        break;
      case 801:
      case 802:
      case 803:
      case 804:
        _weatherIcon = Icon(
          WeatherIcons.cloud,
          size: 150.0,
          color: NordColors.snowStorm.medium,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        _weatherText = "くもり";
        _weatherType = WeatherType.cloudy;
        break;
      default:
        _weatherIcon = Icon(
          WeatherIcons.na,
          color: NordColors.snowStorm.lightest,
        );
        _weatherText = "不明";
    }
    DateFormat format = DateFormat("HH:mm");
    _sunrise = format.format(_weather.sunrise!);
    _sunset = format.format(_weather.sunset!);
  }
}
