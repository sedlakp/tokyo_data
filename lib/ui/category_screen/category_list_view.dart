import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:tokyo_data/ui/sites_screen/site_cell.dart';
import 'package:tokyo_data/ui/detail_site_view.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key, required this.category}) : super(key: key);

  final SiteCategory category;


  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {

  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name),),
      body: Consumer<SitesManager>(builder: (context, sitesManager, child) {
        print("Category list refreshed");
        var sites = sitesManager.sites.where((element) => element.categories.contains(widget.category)).toList();
        return ListView.builder(
          itemCount: sites.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                pushToDetail(context, sites[index]);
              },
                child: SiteCell(site: sites[index]));
          },);
      },
      ),
    );
  }

  void pushToDetail(BuildContext context, CulturalSite site) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return DetailSiteView(site: site,);
        },)
    );
  }
}
