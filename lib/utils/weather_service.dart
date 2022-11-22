import 'package:weather/weather.dart';

class WeatherService {
  final String _apiKey = "09586f9763ec447489de71ed9be619c3";
  late WeatherFactory ws;

  WeatherService() {
    ws = new WeatherFactory(_apiKey);
  }

  Future<Weather> getCurrentWeatherByLocation(
      {required double lat, required double lon}) async {
    return await ws.currentWeatherByLocation(lat, lon);
  }

  Future<List<Weather>> getWeeklyWeather(
      {required double lat, required double lon}) async {
    return await ws.fiveDayForecastByLocation(lat, lon);
  }
}
