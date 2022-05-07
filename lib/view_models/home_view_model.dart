import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather_app/utils/location_service.dart';
import 'package:weather_app/utils/weather_service.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeViewModel extends ChangeNotifier {
  // 画面描画に必要な情報
  String _prefecture = ""; // 都道府県
  String _city = ""; // 市区町村
  IconData _weatherIcon = WeatherIcons.na; // 天候アイコン
  Color _weatherIconColor = Colors.white;
  String _weatherText = ""; // 天候
  String _temperature2MMin = "  . "; // 最低気温
  String _temperature2MMax = "  . "; // 最高気温
  String _sunrise = "  :  "; // 日の出
  String _sunset = "  :  "; // 日の入
  bool _isLoading = true; // ローディング画面 ＯＮ／ＯＦＦ
  String _dateTime = DateFormat("yyyy年MM月dd日").format(DateTime.now());

  double _latitude = 0.0;
  double _longitude = 0.0;

  LocationService locationService = LocationService();
  WeatherService weatherService = WeatherService();

  Daily _daily = Daily();

  String get prefecture => _prefecture;
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

  /// LocationService の getGpsPosition を呼び出し、位置情報を取得する。
  Future<void> getLocAsGps() async {
    // 位置情報を取得取得する
    LocationData _locationData = await locationService.getGpsPosition();

    // 位置情報を基に地名を取得する
    Map<String, dynamic> _locationJson = await locationService.getLocationName(
      latitude: _locationData.latitude!,
      longitude: _locationData.longitude!,
    );

    // JSON配列を LocationNameData に変換する
    LocationNameData _locationName = LocationNameData.fromJson(
      json: _locationJson["response"],
    );

    // 画面の描画に必要なデータを取り出し、保管する
    _prefecture = _locationName.location.first.prefecture;
    _city = _locationName.location.first.city;

    // 緯度／経度を保管する
    _latitude = _locationData.latitude!;
    _longitude = _locationData.longitude!;
  }

  /// 一週間先までの天気予報を取得する
  Future<void> getWeekWeather() async {
    WeekWeather _weekWeather = WeekWeather.fromJson(
        await weatherService.getWeekWeather(_latitude, _longitude));
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

  void streamLocation() {
    Location location = Location();

    location.onLocationChanged.listen((LocationData currentLocation) async {
      // 位置情報を基に地名を取得する
      Map<String, dynamic> _locationJson =
          await locationService.getLocationName(
        latitude: currentLocation.latitude!,
        longitude: currentLocation.longitude!,
      );

      // JSON配列を LocationNameData に変換する
      LocationNameData _locationName = LocationNameData.fromJson(
        json: _locationJson["response"],
      );

      // 画面の描画に必要なデータを取り出し、保管する
      _prefecture = _locationName.location.first.prefecture;
      _city = _locationName.location.first.city;

      // 緯度／経度を保管する
      _latitude = currentLocation.latitude!;
      _longitude = currentLocation.longitude!;
      getWeekWeather();
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
