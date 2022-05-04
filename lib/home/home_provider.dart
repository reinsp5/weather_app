import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/commons/location_service.dart';
import 'package:weather_app/commons/weather_service.dart';

class HomeProvider with ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;
  LocationData _locationData = LocationData.fromMap({});
  LocationService locationService = LocationService();
  //WeekWeather? _weekWeather = null;

  double get latitude => _latitude;
  double get longitude => _longitude;
  //WeekWeather? get weekWeather => _weekWeather;

  set latitude(latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  set longitude(longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  void getLocation() {
    debugPrint("Provider getLocation");
    locationService.getGpsPosition().then((value) {
      _locationData = value;
      _latitude = _locationData.latitude!;
      _longitude = _locationData.longitude!;
      notifyListeners();
    });
  }

  /*Future<WeekWeather?> getWeekWeather() async {
    WeatherService weatherService = WeatherService();
    _weekWeather = await weatherService.getWeekWeather(_latitude, _longitude);
    notifyListeners();
    debugPrint(_weekWeather!.daily.weathercode.toString());
    return _weekWeather;
  }*/
}
