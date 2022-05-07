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
