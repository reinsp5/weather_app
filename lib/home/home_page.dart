import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/home/home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);
    homeProvider.getLocation().then((value) {
      homeProvider.getWeekWeather().then((value) {
        debugPrint(homeProvider.weatherCode.toString());
      });
    });

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[850],
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return Column(
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "天気：" + homeProvider.weatherCode.toString(),
                    style: TextStyle(
                      color: Colors.grey.shade50,
                      fontSize: 21,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
