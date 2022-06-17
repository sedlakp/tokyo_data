import 'package:flutter/material.dart';
import 'package:tokyo_data/Screens/SitesScene/DetailSiteView.dart';
import 'package:tokyo_data/Models/Models.dart';
import 'package:tokyo_data/Screens/SitesScene/SiteCell.dart';
import 'package:tokyo_data/Screens/TimeIndicatorView.dart';

class SiteListView extends StatelessWidget {
  SiteListView({Key? key, required this.sitesManager }): /*onGetNextPage = onGetNextPage ?? ((){}), */super(key: key);

  late final SitesManager sitesManager;
  //final Function onGetNextPage;

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