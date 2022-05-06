import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/home/home_provider.dart';
import 'package:weather_icons/weather_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);
    homeProvider.getLocAsGps().then((value) {
      homeProvider.getWeekWeather();
      homeProvider.streamLocation();
    });

    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // 市区町村
                          homeProvider.city,
                          style: TextStyle(
                            color: Colors.grey[50],
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          // 都道府県
                          homeProvider.prefecture,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BoxedIcon(
                        // 天候アイコン
                        homeProvider.weatherIcon,
                        size: 225,
                        color: homeProvider.weatherIconColor,
                      ),
                      Text(
                        // 天候
                        homeProvider.weatherText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade50,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            color: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // 最高気温
                                      "最高：" +
                                          homeProvider.temperature2MMax +
                                          "℃",
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontSize: 21,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    Text(
                                      // 最低気温
                                      "最低：" +
                                          homeProvider.temperature2MMin +
                                          "℃",
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontSize: 21,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BoxedIcon(
                                      WeatherIcons.sunrise,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        // 日の出時刻
                                        homeProvider.sunrise,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Divider(),
                                    ),
                                    BoxedIcon(
                                      WeatherIcons.sunset,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        // 日の入時刻
                                        homeProvider.sunset,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
