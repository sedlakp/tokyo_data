import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/Models/Models.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
      name: "/stats",
      key: ValueKey("/stats"),
      child: StatsScreen(),
    );
  }

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SitesManager>(
      builder: (context, manager, child) {
        return ListView(
          children: [
            Card(child: Text("Number of sites: ${manager.sites.length}")),
            Card(child: Text("Number of visited sites: ${manager.visitedSites.length}")),
            Card(child: Text("Number of favorited sites: ${manager.favoritedSites.length}"))
          ],
        );
      });
  }
}

