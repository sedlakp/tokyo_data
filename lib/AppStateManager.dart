
import 'dart:async';
import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {

  bool _splashFinished = false;
  bool _dataLoaded = false;
  int _selectedTab = 0;

  bool get splashFinished { return _splashFinished; } // or bool get splashFinished => _splashFinished;
  bool get isDataLoaded { return _dataLoaded; }
  int get selectedTab { return _selectedTab; }

  void initializeApp() {
    Timer(
      const Duration(milliseconds: 2000),
          () {
        _splashFinished = true;
        notifyListeners();
      },
    );
  }

  void dataLoadedFinished() {
    print("Data loaded!");
    _dataLoaded = true;
    notifyListeners();
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }
}