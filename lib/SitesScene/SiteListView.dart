import 'package:flutter/material.dart';
import 'package:tokyo_data/SitesScene/DetailSiteView.dart';
import '../CulturalSite.dart';

class SiteListView extends StatelessWidget {
  SiteListView({Key? key, required this.sites, Function? onGetNextPage }): onGetNextPage = onGetNextPage ?? ((){}), super(key: key);

  final List<CulturalSite> sites;

  final Function onGetNextPage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sites.length+1,
      itemBuilder: (context, index) {
        if (index != sites.length) {
          return GestureDetector(
            onTap: (){
              pushToDetail(context,index);
            },
            child: buildCard(sites[index]),
          );
        } else {
          // TODO: - What happens after no more data not yet handled
          onGetNextPage();
          return const Center(child: CircularProgressIndicator());
        }

      },
    );
  }

  void pushToDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return DetailSiteView(site: sites[index],);
        },)
    );
  }
  
  Card buildCard(CulturalSite site) {
    return Card(
        child:ListTile(
          title: Text(site.name),
          subtitle: Text(site.englishName),
    )
    );
  }
}