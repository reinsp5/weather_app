import 'dart:async';
import 'dart:developer';

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
  late MyWeather _weather;
  late List<MyWeather> _weeklyWeather;
  late Icon _weatherIcon; // 天候アイコン
  String _state = ""; // 都道府県
  String _city = ""; // 市区町村
  String _weatherText = ""; // 天候
  String _temperature2MMin = "  . "; // 最低気温
  String _temperature2MMax = "  . "; // 最高気温
  bool _isLoading = true; // ローディング画面 ＯＮ／ＯＦＦ

  double _latitude = 0.0;
  double _longitude = 0.0;

  WeatherType _weatherType = WeatherType.sunny;

  LocationService locationService = LocationService();
  WeatherService weatherService = WeatherService();

  MyWeather get weather => _weather;
  List<MyWeather> get weeklyWeather => _weeklyWeather;
  String get state => _state;
  String get city => _city;
  Icon get weatherIcon => _weatherIcon;
  // List<Color> get weatherIconColor => _weatherIconColor;
  String get weatherText => _weatherText;
  String get temperature2MMin => _temperature2MMin;
  String get temperature2MMax => _temperature2MMax;
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
    Weather wes = await weatherService.getCurrentWeatherByLocation(
      lat: _latitude,
      lon: _longitude,
    );
    _weather = convWeather(wes);
    DateFormat format = DateFormat("HH:mm");
    _weather.sunriseText = format.format(_weather.sunrise!);
    _weather.sunsetText = format.format(_weather.sunset!);

    List<Weather> weeklyWeathers = await weatherService.getWeeklyWeather(
      lat: _latitude,
      lon: _longitude,
    );
    _weeklyWeather = [];
    for (Weather wes in weeklyWeathers) {
      _weeklyWeather.add(convWeather(wes));
      log("${wes.date}");
    }
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

  /// WeatherをMyWeatherに変換する
  MyWeather convWeather(Weather weather) {
    MyWeather myWeather = MyWeather(weather.toJson()!);
    switch (myWeather.weatherConditionCode) {
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
        myWeather.weatherIconData = Icon(
          WeatherIcons.thunderstorm,
          color: NordColors.aurora.yellow,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        myWeather.weatherText = "雷雨";
        myWeather.weatherType = WeatherType.thunder;
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
        myWeather.weatherIconData = Icon(
          WeatherIcons.day_showers,
          color: NordColors.frost.darkest,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        myWeather.weatherText = "霧雨";
        myWeather.weatherType = WeatherType.lightRainy;
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
        myWeather.weatherIconData = Icon(
          WeatherIcons.rain,
          size: 150.0,
          color: NordColors.frost.darkest,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        myWeather.weatherText = "雨";
        myWeather.weatherType = WeatherType.middleRainy;
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
        myWeather.weatherIconData = Icon(
          WeatherIcons.snow,
          color: NordColors.snowStorm.lightest,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        myWeather.weatherText = "雪";
        myWeather.weatherType = WeatherType.middleSnow;
        break;
      // 霞
      case 701:
        myWeather.weatherIconData = Icon(
          WeatherIcons.snow,
          color: NordColors.snowStorm.medium,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        myWeather.weatherText = "霞";
        myWeather.weatherType = WeatherType.hazy;
        break;
      // 霧
      case 741:
        myWeather.weatherIconData = Icon(
          WeatherIcons.day_fog,
          color: NordColors.snowStorm.medium,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        myWeather.weatherText = "霧";
        myWeather.weatherType = WeatherType.foggy;
        break;
      case 800:
        myWeather.weatherIconData = Icon(
          WeatherIcons.day_sunny,
          color: NordColors.aurora.orange,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        );
        myWeather.weatherText = "晴れ";
        myWeather.weatherType = WeatherType.sunny;
        break;
      case 801:
      case 802:
      case 803:
      case 804:
        myWeather.weatherIconData = Icon(
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
        myWeather.weatherText = "くもり";
        myWeather.weatherType = WeatherType.cloudy;
        break;
      default:
        myWeather.weatherIconData = Icon(
          WeatherIcons.na,
          color: NordColors.snowStorm.lightest,
        );
        myWeather.weatherText = "不明";
    }

    return myWeather;
  }
}
