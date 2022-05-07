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
