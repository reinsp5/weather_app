import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
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
      homeViewModel.setCurrentWeather();
      // homeViewModel.getWeekWeather();
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
              return WeatherWidget(homeViewModel: homeViewModel);
            }
          },
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WeatherBg(
          weatherType: WeatherType.sunny,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(20),
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
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(
                        // 天候アイコン
                        WeatherIcons.cloud,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    // 天候
                    homeViewModel.weather.weatherMain!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: NordColors.snowStorm.lightest,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
                                "最高：" + homeViewModel.temperature2MMax + "℃",
                                style: TextStyle(
                                  color: NordColors.aurora.red,
                                  fontSize: 21,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Divider(),
                              ),
                              Text(
                                // 最低気温
                                "最低：" + homeViewModel.temperature2MMin + "℃",
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
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
        )
      ],
    );
  }
}
