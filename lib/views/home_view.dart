import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/view_models/home_view_model.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.getLocAsGps().then((value) {
      homeViewModel.getWeekWeather();
      homeViewModel.streamLocation();
    });

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Consumer<HomeViewModel>(
          builder: (context, provider, _) {
            if (homeViewModel.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 8.0,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("yyyy年MM月dd日").format(DateTime.now()),
                          style: TextStyle(
                            color: NordColors.snowStorm.lightest,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          // 市区町村
                          homeViewModel.city,
                          style: TextStyle(
                            color: NordColors.snowStorm.lightest,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          // 都道府県
                          homeViewModel.state,
                          style: TextStyle(
                            color: NordColors.snowStorm.lightest,
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
                        homeViewModel.weatherIcon.first,
                        size: 200,
                        color: homeViewModel.weatherIconColor.first,
                      ),
                      Text(
                        // 天候
                        homeViewModel.weatherText.first,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: NordColors.snowStorm.lightest,
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
                            color: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // 最高気温
                                      "最高：" +
                                          homeViewModel.temperature2MMax +
                                          "℃",
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
                                      "最低：" +
                                          homeViewModel.temperature2MMin +
                                          "℃",
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
                                        homeViewModel.sunrise,
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
                                        homeViewModel.sunset,
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
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
