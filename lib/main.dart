import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/tokyo_theme.dart';
import 'models/models.dart';
import 'approuter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _appStateManager = AppStateManager();
  final _sitesManager = SitesManager();
  late Approuter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = Approuter(
      appStateManager: _appStateManager,

    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _appStateManager),
        ChangeNotifierProvider(create: (context) => _sitesManager),
      ],
      child: MaterialApp(
        title: 'Tokyo culture sites',
        theme: TokyoTheme.light(),
        home: Router(
          routerDelegate: _appRouter,
          backButtonDispatcher: RootBackButtonDispatcher(),
        )
        ),
    );
  }

}