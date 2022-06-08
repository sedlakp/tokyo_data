import 'package:flutter/material.dart';
import 'package:tokyo_data/SitesScene/DetailSiteView.dart';
import '../CulturalSite.dart';

class SiteListView extends StatelessWidget {
  const SiteListView({Key? key, required this.sites}) : super(key: key);

  final List<CulturalSite> sites;

  static const test = [1,2,3,4,5,6,7,8];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sites.length,
      itemBuilder: (context, index) {
        return GestureDetector(onTap: () {
          Navigator.push(context, 
              MaterialPageRoute(builder: (context) {
                return DetailSiteView(site: sites[index],);
              },)
          );
        },
          child: buildCard(sites[index]),
        );
      },
    );
  }
  
  
  Card buildCard(CulturalSite site) {
    return Card(
        child:ListTile(
          title: Text(site.name),
          subtitle: Text(site.description.first),
    )
    );
  }
}