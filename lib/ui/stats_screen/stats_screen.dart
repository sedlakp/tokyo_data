import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/models/models.dart';
import 'tokyo_bar_graph.dart';
import 'tokyo_pie_graph.dart';

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
            TokyoBarGraph(barData: manager.userData, barWidth: 30,),
            TokyoPieGraph(pieName:"Site Categories", items: categoryData(manager),),
          ],
        );
      });
  }


  List<TokyoPieItem> categoryData(SitesManager sitesManager) {
    return SiteCategory.categoriesNoCulturalProperty().map((cat) {
      var sites = sitesManager.sites.where((element) => element.categories.contains(cat)).toList();
      return TokyoPieItem(cat.name, sites.length.toDouble());
    }).toList();

  }

}

