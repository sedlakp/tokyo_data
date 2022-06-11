import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/SitesManager.dart';

class MapScreenView extends StatefulWidget {
  const MapScreenView({Key? key}) : super(key: key);

  @override
  State<MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<MapScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${Provider.of<SitesManager>(context,listen: false).sites.length}"),
      ),
    );
  }
}
