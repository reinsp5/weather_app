import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

import 'default_location_setting_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Licence",
                style: TextStyle(
                  color: NordColors.snowStorm.lightest,
                  fontSize: 20,
                ),
              ),
              leading: Icon(
                Icons.info_outline,
                color: NordColors.snowStorm.lightest,
                size: 30,
              ),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: "お天気アプリ",
                applicationLegalese: "Flutter学習のために作成したアプリです。",
                applicationVersion: "v1.0.0",
                applicationIcon: FlutterLogo(
                  size: 40,
                ),
              ),
            ),
            Divider(
              color: NordColors.snowStorm.lightest,
            ),
          ],
        ),
      ),
    );
  }
}
