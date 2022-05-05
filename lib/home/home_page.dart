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
    homeProvider.getLocation().then((value) {
      homeProvider.getWeekWeather().then((value) {});
    });

    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.grey[900],
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homeProvider.city,
                        style: TextStyle(
                          color: Colors.grey[50],
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        homeProvider.prefecture,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      BoxedIcon(
                        WeatherIcons.day_sunny,
                        size: 225,
                        color: Colors.orange.shade600,
                      ),
                      Text(
                        "晴れ",
                        style: TextStyle(
                          color: Colors.grey.shade50,
                          fontSize: 32,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "最高：26℃",
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 21,
                            ),
                          ),
                          VerticalDivider(),
                          Text(
                            "最低：19℃",
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
                          Text(
                            "日出：04:30",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          VerticalDivider(),
                          BoxedIcon(
                            WeatherIcons.sunset,
                            color: Colors.white,
                          ),
                          Text(
                            "日入：18:45",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
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
