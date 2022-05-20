import 'dart:convert';

WeeklyWeather weeklyWeatherFromJson(String str) =>
    WeeklyWeather.fromJson(json.decode(str));

String weeklyWeatherToJson(WeeklyWeather data) => json.encode(data.toJson());

class WeeklyWeather {
  WeeklyWeather({
    required this.longitude,
    required this.generationtimeMs,
    required this.dailyUnits,
    required this.latitude,
    required this.utcOffsetSeconds,
    required this.elevation,
    required this.daily,
  });

  double longitude;
  double generationtimeMs;
  DailyUnits dailyUnits;
  double latitude;
  int utcOffsetSeconds;
  double elevation;
  Daily daily;

  factory WeeklyWeather.fromJson(Map<String, dynamic> json) => WeeklyWeather(
        longitude: json["longitude"].toDouble(),
        generationtimeMs: json["generationtime_ms"].toDouble(),
        dailyUnits: DailyUnits.fromJson(json["daily_units"]),
        latitude: json["latitude"].toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        elevation: json["elevation"].toDouble(),
        daily: Daily.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "daily_units": dailyUnits.toJson(),
        "latitude": latitude,
        "utc_offset_seconds": utcOffsetSeconds,
        "elevation": elevation,
        "daily": daily.toJson(),
      };
}

class Daily {
  Daily({
    required this.weathercode,
    required this.precipitationSum,
    required this.windspeed10MMax,
    required this.time,
    required this.sunset,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.sunrise,
  });

  List<int> weathercode;
  List<double> precipitationSum;
  List<double> windspeed10MMax;
  List<DateTime> time;
  List<String> sunset;
  List<double> temperature2MMax;
  List<double> temperature2MMin;
  List<String> sunrise;

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        weathercode: List<int>.from(json["weathercode"].map((x) => x)),
        precipitationSum: List<double>.from(
            json["precipitation_sum"].map((x) => x.toDouble())),
        windspeed10MMax: List<double>.from(
            json["windspeed_10m_max"].map((x) => x.toDouble())),
        time: List<DateTime>.from(json["time"].map((x) => DateTime.parse(x))),
        sunset: List<String>.from(json["sunset"].map((x) => x)),
        temperature2MMax: List<double>.from(
            json["temperature_2m_max"].map((x) => x.toDouble())),
        temperature2MMin: List<double>.from(
            json["temperature_2m_min"].map((x) => x.toDouble())),
        sunrise: List<String>.from(json["sunrise"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "weathercode": List<dynamic>.from(weathercode.map((x) => x)),
        "precipitation_sum": List<dynamic>.from(precipitationSum.map((x) => x)),
        "windspeed_10m_max": List<dynamic>.from(windspeed10MMax.map((x) => x)),
        "time": List<dynamic>.from(time.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "sunset": List<dynamic>.from(sunset.map((x) => x)),
        "temperature_2m_max":
            List<dynamic>.from(temperature2MMax.map((x) => x)),
        "temperature_2m_min":
            List<dynamic>.from(temperature2MMin.map((x) => x)),
        "sunrise": List<dynamic>.from(sunrise.map((x) => x)),
      };
}

class DailyUnits {
  DailyUnits({
    required this.weathercode,
    required this.precipitationSum,
    required this.windspeed10MMax,
    required this.time,
    required this.sunset,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.sunrise,
  });

  String weathercode;
  String precipitationSum;
  String windspeed10MMax;
  String time;
  String sunset;
  String temperature2MMax;
  String temperature2MMin;
  String sunrise;

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
        weathercode: json["weathercode"],
        precipitationSum: json["precipitation_sum"],
        windspeed10MMax: json["windspeed_10m_max"],
        time: json["time"],
        sunset: json["sunset"],
        temperature2MMax: json["temperature_2m_max"],
        temperature2MMin: json["temperature_2m_min"],
        sunrise: json["sunrise"],
      );

  Map<String, dynamic> toJson() => {
        "weathercode": weathercode,
        "precipitation_sum": precipitationSum,
        "windspeed_10m_max": windspeed10MMax,
        "time": time,
        "sunset": sunset,
        "temperature_2m_max": temperature2MMax,
        "temperature_2m_min": temperature2MMin,
        "sunrise": sunrise,
      };
}
