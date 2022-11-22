import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/view_models/home_view_model.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: 60),
      child: FutureBuilder(
        future:
            Provider.of<HomeViewModel>(context, listen: false).getLocAsGps(),
        builder: (context, snapshot) {
          // 通信中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 8.0,
              ),
            );
          }

          // エラー発生
          if (snapshot.error != null) {
            print(snapshot.error);
            return const Center(
              child: Text('エラーが発生しました。'),
            );
          }

          return Consumer<HomeViewModel>(
            builder: (context, provider, _) {
              return WeatherWidget(homeViewModel: provider);
            },
          );
        },
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  WeatherWidget({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  DateFormat format = DateFormat("MM/dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WeatherBg(
          weatherType: homeViewModel.weatherType,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                  top: 80,
                  left: 35,
                  right: 35,
                  bottom: 20,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("yyyy年MM月dd日").format(DateTime.now()),
                      style: TextStyle(
                        color: NordColors.snowStorm.lightest,
                        shadows: const [
                          Shadow(
                            blurRadius: 10.0,
                            offset: Offset(1.5, 1.5),
                          )
                        ],
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      // 市区町村
                      homeViewModel.city,
                      style: TextStyle(
                        color: NordColors.snowStorm.lightest,
                        shadows: const [
                          Shadow(
                            blurRadius: 10.0,
                            offset: Offset(1.5, 1.5),
                          )
                        ],
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // 都道府県
                      homeViewModel.state,
                      style: TextStyle(
                        color: NordColors.snowStorm.lightest,
                        shadows: const [
                          Shadow(
                            blurRadius: 10.0,
                            offset: Offset(1.5, 1.5),
                          )
                        ],
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: homeViewModel.weather.weatherIconData,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      // 天候
                      homeViewModel.weather.weatherText!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: NordColors.snowStorm.lightest,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // 温度
              Center(
                child: SizedBox(
                  width: 300,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // 最高気温
                                  "最高：${homeViewModel.weather.tempMax!.celsius!.toStringAsFixed(1)}℃",
                                  style: TextStyle(
                                    color: NordColors.aurora.red,
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
                                  "最低：${homeViewModel.weather.tempMin!.celsius!.toStringAsFixed(1)}℃",
                                  style: TextStyle(
                                    color: NordColors.frost.darkest,
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
                                  color: NordColors.snowStorm.lightest,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    // 日の出時刻
                                    homeViewModel.weather.sunriseText!,
                                    style: TextStyle(
                                      color: NordColors.snowStorm.lightest,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      // ignore: unnecessary_const
                                      const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                  child: Divider(),
                                ),
                                BoxedIcon(
                                  WeatherIcons.sunset,
                                  color: NordColors.snowStorm.lightest,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    // 日の入時刻
                                    homeViewModel.weather.sunsetText!,
                                    style: TextStyle(
                                      color: NordColors.snowStorm.lightest,
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
              // 降水確率
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 140,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      top: 15,
                                    ),
                                    child: Icon(
                                      WeatherIcons.raindrop,
                                      size: 40,
                                      color: NordColors.snowStorm.lightest,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "降水量",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "${homeViewModel.weather.rainLastHour ?? 0} ml",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // 風速
                  Center(
                    child: SizedBox(
                      width: 140,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      top: 15,
                                    ),
                                    child: Icon(
                                      WeatherIcons.wind_deg_0,
                                      size: 40,
                                      color: NordColors.snowStorm.lightest,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "風速",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "${homeViewModel.weather.windSpeed} m/h",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
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
              // 週間天気
              for (MyWeather weather in homeViewModel.weeklyWeather)
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                    left: 15,
                                  ),
                                  child: Icon(
                                    weather.weatherIconData!.icon,
                                    color: NordColors.snowStorm.medium,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Text(
                                  "${format.format(weather.date!)}",
                                  style: TextStyle(
                                    color: NordColors.snowStorm.medium,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Text(
                                  "${weather.weatherText}",
                                  style: TextStyle(
                                    color: NordColors.snowStorm.medium,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
}
