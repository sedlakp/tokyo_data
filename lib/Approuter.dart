

import 'package:flutter/material.dart';
import 'package:tokyo_data/Models/Models.dart';
import 'package:tokyo_data/Screens/Screens.dart';

//https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade

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
        // last in this array is on top of the stack
        // when this gets too complicated I can make a function that returns list of current pages
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