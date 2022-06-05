import 'package:flutter/material.dart';
import 'CulturalSite.dart';
import 'APIService.dart';
import 'SiteListView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<void> _initSite;
  List<CulturalSite> sites = [];

  @override
  void initState() {
    super.initState();
    _initSite = _initSites();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokyo culture sites',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tokyo culture sites'),
        ),
        body: FutureBuilder(
          future: _initSite,
          builder: (BuildContext context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                {
                  return const Center(
                    child: Text('Loading...'),
                  );
                }
              case ConnectionState.done:
                {
                  return RefreshIndicator(
                      onRefresh: _refreshSites,
                      child: SiteListView(sites: sites),
                      );
                }
            }
          },
        ),
      ),
      );
  }

  Future<void> _initSites() async {
    final sites = await APIService.fetchCulturalSites(limit: 20);
    this.sites = sites;
  }

  Future<void> _refreshSites() async {
    final sites = await APIService.fetchCulturalSites(limit: 20);
    setState(() {
      this.sites = sites;
    });
  }

}