import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  set pageIndex(index) {
    _pageIndex = index;
    notifyListeners();
  }
}
