import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: Colors.grey.shade900,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 3));
          debugPrint("refresh completed.");
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: _WeeklyHeaderDelegate(),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: columns(),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> columns() {
    List<Widget> columns = [];

    for (var i = 0; i < 7; i++) {
      Widget widget = Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            BoxedIcon(
              WeatherIcons.day_sunny,
              color: Colors.white,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "晴れ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "最高：23℃",
                        style: TextStyle(
                          color: Colors.red.shade600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: Text(
                          "最低：19℃",
                          style: TextStyle(
                            color: Colors.blue.shade600,
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
    return Container(
      height: 200,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "2022/05/10",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          Text(
            // 市区町村
            "札幌市中央区",
            style: TextStyle(
              color: Colors.grey[50],
              fontSize: 45,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            // 都道府県
            "北海道",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 200;

  @override
  // TODO: implement minExtent
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
