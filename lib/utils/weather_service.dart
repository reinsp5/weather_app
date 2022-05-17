import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _domain = "api.open-meteo.com";

  Future<dynamic> getWeeklyWeather(latitude, longitude) async {
    Map<String, dynamic> _parms = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "timezone": "Asia/Tokyo",
    };
    Uri _uri = Uri.https(_domain, '/v1/forecast', _parms);
    String _url = _uri.toString() +
        "&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset";
    http.Response _response = await http.get(Uri.parse(_url));
    return jsonDecode(_response.body);
  }
}
