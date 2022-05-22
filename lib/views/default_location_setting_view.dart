import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

class DefaultLocationSettingView extends StatelessWidget {
  const DefaultLocationSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NordColors.polarNight.darkest,
      appBar: AppBar(
        title: const Text("デフォルト地域設定"),
        backgroundColor: Colors.black54,
      ),
      body: const DefaultLocationSetting(),
    );
  }
}

class DefaultLocationSetting extends StatelessWidget {
  const DefaultLocationSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(
                color: NordColors.snowStorm.lightest,
              ),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: NordColors.snowStorm.lightest,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: NordColors.snowStorm.lightest,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: NordColors.snowStorm.lightest,
                  ),
                ),
                labelText: '地名を入力',
                labelStyle: TextStyle(
                  color: NordColors.snowStorm.lightest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
