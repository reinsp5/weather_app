import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
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
