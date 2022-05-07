import 'package:flutter/material.dart';
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
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Consumer<HomeViewModel>(
          builder: (context, provider, _) {
            return homeViewModel.isLoading
                ? Container(
                    // isLoading が true なのでローディング画面を表示
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 8.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    // isLoading が false なのでコンテンツを表示
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                homeViewModel.dateTime,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                // 市区町村
                                homeViewModel.city,
                                style: TextStyle(
                                  color: Colors.grey[50],
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                // 都道府県
                                homeViewModel.prefecture,
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
                              homeViewModel.weatherIcon,
                              size: 200,
                              color: homeViewModel.weatherIconColor,
                            ),
                            Text(
                              // 天候
                              homeViewModel.weatherText,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            // 最高気温
                                            "最高：" +
                                                homeViewModel.temperature2MMax +
                                                "℃",
                                            style: TextStyle(
                                              color: Colors.red.shade600,
                                              fontSize: 21,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Divider(),
                                          ),
                                          Text(
                                            // 最低気温
                                            "最低：" +
                                                homeViewModel.temperature2MMin +
                                                "℃",
                                            style: TextStyle(
                                              color: Colors.blue.shade600,
                                              fontSize: 21,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          BoxedIcon(
                                            WeatherIcons.sunrise,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              // 日の出時刻
                                              homeViewModel.sunrise,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Divider(),
                                          ),
                                          BoxedIcon(
                                            WeatherIcons.sunset,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              // 日の入時刻
                                              homeViewModel.sunset,
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
