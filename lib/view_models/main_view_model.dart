import 'package:flutter/material.dart';

class MainViewModel with ChangeNotifier {
  int _pageIndex = 1;

  int get pageIndex => _pageIndex;

  set pageIndex(index) {
    _pageIndex = index;
    notifyListeners();
  }
}
