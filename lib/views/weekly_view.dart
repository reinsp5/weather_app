import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/view_models/home_view_model.dart';
import 'package:weather_icons/weather_icons.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: Colors.black54,
        onRefresh: () async {
          // await context.read<HomeViewModel>().getWeekWeather();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: _WeeklyHeaderDelegate(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [],
                    // columns(
                    //     icons: context.select((HomeViewModel homeViewModel) =>
                    //         homeViewModel.weatherIcon),
                    //     colors: context.select((HomeViewModel homeViewModel) =>
                    //         homeViewModel.weatherIconColor),
                    //     texts: context.select((HomeViewModel homeViewModel) =>
                    //         homeViewModel.weatherText),
                    //     daily: context.select((HomeViewModel homeViewModel) =>
                    //         homeViewModel.daily)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> columns({
    required List<IconData> icons,
    required List<Color> colors,
    required List<String> texts,
    required Daily daily,
  }) {
    List<Widget> columns = [];
    for (var i = 0; i < texts.length; i++) {
      Widget widget = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            BoxedIcon(
              icons[i],
              color: colors[i],
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("yyyy年MM月dd日")
                            .format(DateTime.now().add(Duration(days: i))),
                        style: TextStyle(
                          color: NordColors.snowStorm.lightest,
                          fontSize: 18,
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                        width: 8.0,
                      ),
                      Text(
                        texts[i],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "最高：" + daily.temperature2MMax[i].toString() + "℃",
                        style: TextStyle(
                          color: NordColors.aurora.red,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: Text(
                          "最低：" + daily.temperature2MMin[i].toString() + "℃",
                          style: TextStyle(
                            color: NordColors.frost.darkest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      columns.add(widget);
      widget = Divider(
        color: Colors.grey.shade300,
      );
      columns.add(widget);
    }
    return columns;
  }
}

class _WeeklyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    HomeViewModel homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    return SafeArea(
      child: Container(
        height: 150,
        color: Colors.black54,
        child: Consumer<HomeViewModel>(builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  homeViewModel.state,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
