import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/Models/Models.dart';
import 'package:tokyo_data/Screens/tokyo_bar_graph.dart';
import 'package:tokyo_data/Screens/tokyo_pie_graph.dart';

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

  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<SitesManager>(
      builder: (context, manager, child) {
        return ListView(
          children: [
            TokyoBarGraph(barData: manager.userData,barWidth: 30,),
            TokyoPieGraph(),
            Card(child: Text("Number of sites: ${manager.sites.length}")),
            Card(child: Text("Number of visited sites: ${manager.visitedSites.length}")),
            Card(child: Text("Number of favorited sites: ${manager.favoritedSites.length}")),
            Card(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getCategories(manager),
            ),),
          ],
        );
      });
  }

  List<Widget> _getCategories(SitesManager manager) {
    return SiteCategory.values.map((cat) {
      var sites = manager.sites.where((element) => element.categories.contains(cat)).toList();
      return Text("${cat.name} : ${sites.length}", textAlign: TextAlign.left,);
    },).toList();
  }

}

