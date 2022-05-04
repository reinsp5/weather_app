import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationService {
  final String _domain = "msearch.gsi.go.jp";

  /// 日本語の地名を基に緯度／経度を取得する
  Future<String> getLocation(locationName) async {
    Map<String, dynamic> _parms = {
      "q": locationName,
    };
    Uri _uri = Uri.https(_domain, '/address-search/AddressSearch', _parms);
    http.Response response = await http.get(Uri.parse(_uri.toString()));
    debugPrint(response.body);
    return response.body;
  }

  /// GPS情報から緯度／経度を取得する
  Future<LocationData> getGpsPosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error("");
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error("");
      }
    }

    return _locationData = await location.getLocation();
  }
}
