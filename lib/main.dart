import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/home/home_provider.dart';
import 'package:weather_app/main_provider.dart';
import 'package:weather_app/settings/settings_page.dart';
import 'home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.sawarabiGothicTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        title: 'Flutter Demo',
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  /// アプリケーションのページ
  List<Widget> _pages = [
    HomePage(),
    HomePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: _pages[mainProvider.pageIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        cornerRadius: 15.0,
        backgroundColor: Colors.black,
        items: const [
          TabItem(icon: Icons.map, title: "全国"),
          TabItem(icon: Icons.home, title: "ホーム"),
          TabItem(icon: Icons.settings, title: "設定"),
        ],
        initialActiveIndex: 1,
        onTap: (int i) {
          debugPrint("taped index$i");
          mainProvider.pageIndex = i;
          debugPrint(i.toString());
        },
      ),
    );
  }
}
