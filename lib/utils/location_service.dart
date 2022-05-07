import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationService {
  final String _locName2Loc = "msearch.gsi.go.jp";
  final String _loc2LocName = "geoapi.heartrails.com";

  /// 日本語の地名を基に緯度／経度を取得する
  Future<String> getLocation(locationName) async {
    Map<String, dynamic> _parms = {
      "q": locationName,
    };
    Uri _uri = Uri.https(_locName2Loc, '/address-search/AddressSearch', _parms);
    http.Response response = await http.get(Uri.parse(_uri.toString()));
    return response.body;
  }

  /// GPS情報から緯度／経度を取得する
  Future<LocationData> getGpsPosition() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // 位置情報は有効か？
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      // 有効化するよう要求し、その結果を検証
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error("位置情報サービスが有効ではありません。");
      }
    }

    // 位置情報サービスの利用権限はあるか？
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      // 位置情報サービスの利用権限を与えるよう要求し、その結果を検証
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error("位置情報サービスの利用権限がありません。");
      }
    }

    return await location.getLocation();
  }

  /// 緯度／経度 を基に「地名」を検索する
  Future<Map<String, dynamic>> getLocationName(
      {double latitude = 0.0, double longitude = 0.0}) async {
    Map<String, dynamic> _parms = {
      "method": "searchByGeoLocation",
      "x": longitude.toString(),
      "y": latitude.toString(),
    };
    Uri _uri = Uri.http(_loc2LocName, '/api/json', _parms);
    http.Response response = await http.get(Uri.parse(_uri.toString()),
        headers: {"Content-Type": "application/xml;charset=utf-8"});
    Map<String, dynamic> json = jsonDecode(response.body);
    return json;
  }
}
