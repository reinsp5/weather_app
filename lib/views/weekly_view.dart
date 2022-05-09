import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            title: Text(
              "札幌市中央区",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            backgroundColor: Colors.black,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    BoxedIcon(
                      WeatherIcons.day_sunny,
                      size: 50,
                    ),
                    Text(
                      "晴れ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
