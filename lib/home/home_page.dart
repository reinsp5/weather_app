import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/commons/weather_service.dart';
import 'package:weather_app/home/home_provider.dart';

import '../commons/location_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("home_page build");
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "ホーム画面",
                style: TextStyle(
                  color: Colors.grey[50],
                  fontSize: 32,
                ),
              ),
            ),
            Text("緯度：" + homeProvider.latitude.toString()),
            Text("経度：" + homeProvider.longitude.toString()),
          ],
        ),
      ),
    );
  }
}
