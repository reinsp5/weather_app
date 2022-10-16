import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';

class WeatherService {
  final String _domain = "api.open-meteo.com";

  final String _apiKey = "09586f9763ec447489de71ed9be619c3";
  late WeatherFactory ws;

  WeatherService() {
    ws = new WeatherFactory(_apiKey);
  }

  Future<Weather> getCurrentWeatherByLocation(
      {required double lat, required double lon}) async {
    return await ws.currentWeatherByLocation(lat, lon);
  }

  Future<dynamic> getWeeklyWeather(latitude, longitude) async {
    Map<String, dynamic> _parms = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "timezone": "Asia/Tokyo",
    };
    Uri _uri = Uri.https(_domain, '/v1/forecast', _parms);
    String _url = _uri.toString() +
        "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,windspeed_10m_max";
    http.Response _response = await http.get(Uri.parse(_url));
    return jsonDecode(_response.body);
  }
}
