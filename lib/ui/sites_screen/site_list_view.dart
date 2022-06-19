import 'package:flutter/material.dart';
import 'package:tokyo_data/ui/screens.dart';
import 'package:tokyo_data/models/models.dart';
import 'site_cell.dart';

class SiteListView extends StatelessWidget {
  const SiteListView({Key? key, required this.sitesManager }): super(key: key);

  final SitesManager sitesManager;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sitesManager.sites.length,
      itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              pushToDetail(context,index);
            },
            child: SiteCell(site: sitesManager.sites[index]),
          );
      },
    );
  }

  void pushToDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return DetailSiteView(site: sitesManager.sites[index],);
        },)
    );
  }
  
}