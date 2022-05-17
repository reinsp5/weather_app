import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/view_models/home_view_model.dart';
import 'package:weather_app/view_models/main_view_model.dart';
import 'package:weather_app/views/settings_view.dart';
import 'package:weather_app/views/weekly_view.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

/// アプリケーションのページ
List<Widget> pages = [
  const WeeklyView(),
  const HomeView(),
  const SettingsPage(),
];

int pageIndex = 1;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.sawarabiGothicTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        title: 'Flutter Demo',
        home: DefaultTabController(
          length: pages.length,
          child: const MainPage(),
          initialIndex: pageIndex,
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: TabBarView(
        children: pages,
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        cornerRadius: 15.0,
        backgroundColor: Colors.black,
        items: const [
          TabItem(icon: Icons.view_week, title: "週間天気"),
          TabItem(icon: Icons.home, title: "ホーム"),
          TabItem(icon: Icons.settings, title: "設定"),
        ],
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
