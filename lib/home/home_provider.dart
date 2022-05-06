import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/commons/location_service.dart';
import 'package:weather_app/commons/weather_service.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeProvider with ChangeNotifier {
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

    notifyListeners();
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
      notifyListeners();
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

class WeekWeather {
  WeekWeather({
    this.generationtimeMs = 0.0,
    this.longitude = 0.0,
    required this.dailyUnits,
    this.elevation = 0.0,
    this.latitude = 0.0,
    this.utcOffsetSeconds = 0,
    required this.daily,
  });

  double generationtimeMs;
  double longitude;
  DailyUnits dailyUnits = DailyUnits();
  double elevation;
  double latitude;
  int utcOffsetSeconds;
  Daily daily = Daily();

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
    this.sunset = const [],
    this.sunrise = const [],
    this.temperature2MMin = const [],
    this.temperature2MMax = const [],
    this.time = const [],
    this.weathercode = const [],
  });

  List<String> sunset;
  List<String> sunrise;
  List<double> temperature2MMin;
  List<double> temperature2MMax;
  List<DateTime> time;
  List<int> weathercode;

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
    this.sunset = "",
    this.sunrise = "",
    this.temperature2MMin = "",
    this.temperature2MMax = "",
    this.time = "",
    this.weathercode = "",
  });

  String sunset;
  String sunrise;
  String temperature2MMin;
  String temperature2MMax;
  String time;
  String weathercode;

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

class LocationNameData {
  LocationNameData({
    required this.location,
  });

  List<LocationName> location;

  factory LocationNameData.fromJson({required Map<String, dynamic> json}) =>
      LocationNameData(
        location: List<LocationName>.from(
            json["location"].map((x) => LocationName.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "location": List<dynamic>.from(location.map((x) => x.toJson())),
      };
}

class LocationName {
  LocationName({
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

  factory LocationName.fromJson(Map<String, dynamic> json) => LocationName(
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
