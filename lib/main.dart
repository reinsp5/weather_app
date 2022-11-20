import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/view_models/home_view_model.dart';
import 'package:weather_app/view_models/main_view_model.dart';
import 'package:weather_app/views/settings_view.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

/// アプリケーションのページ
List<Widget> pages = [
  // const WeeklyView(),
  const HomeView(),
  const SettingsView(),
];

enum PageIndex { Home, Settings }

int pageIndex = 0;

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
          useMaterial3: true,
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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: NordColors.polarNight.darkest,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('ホーム'),
              selected: PageIndex.Home.index == pageIndex,
              onTap: () => setState(() {
                pageIndex = 0;
                scaffoldKey.currentState!.closeDrawer();
              }),
            ),
            ListTile(
              title: Text('設定'),
              selected: PageIndex.Settings.index == pageIndex,
              onTap: () => setState(() {
                pageIndex = 1;
                scaffoldKey.currentState!.closeDrawer();
              }),
            ),
          ],
        ),
      ),
      body: pages[pageIndex],
    );
  }
}
