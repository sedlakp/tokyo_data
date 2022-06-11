

import 'package:flutter/material.dart';
import 'package:tokyo_data/AppStateManager.dart';
import 'package:tokyo_data/LoadingScreen.dart';
import 'package:tokyo_data/SplashScreen.dart';

import 'package:tokyo_data/Home.dart';

class Approuter extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  final AppStateManager appStateManager;

  Approuter({required this.appStateManager}) : // named required parameters
      navigatorKey = GlobalKey<NavigatorState>() { // known parameters value
    appStateManager.addListener(notifyListeners); // further init setup
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
          if (!appStateManager.splashFinished) SplashScreen.page(),
          if (appStateManager.splashFinished && !appStateManager.isDataLoaded) LoadingScreen.page(),
          if (appStateManager.isDataLoaded) Home.page(appStateManager.selectedTab),
      ],
    );
  }

  bool _handlePopPage( Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) async {
    return;
  }

}