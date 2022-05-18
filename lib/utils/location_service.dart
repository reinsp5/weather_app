import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// ロケーションサービスが使用可能かどうかチェックする
  Future<bool> checkPermission() async {
    bool serviceEnabled = false;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(false);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(false);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.error(false);
    }

    return Future.value(true);
  }

  /// 現在位置を取得する
  Future<Position> getCurrentPosition() async {
    if (!await checkPermission()) return Future.error(false);

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Placemark> getCurrentPositionName({required Position position}) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placeMarks.first;
  }
}
