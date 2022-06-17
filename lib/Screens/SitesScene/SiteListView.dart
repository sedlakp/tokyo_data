import 'package:flutter/material.dart';
import 'package:tokyo_data/Screens/SitesScene/DetailSiteView.dart';
import 'package:tokyo_data/Models/Models.dart';
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
            child: buildCard(sitesManager.sites[index]),
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
  
  Card buildCard(CulturalSite site) {
    return Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(site.name, style: const TextStyle(fontWeight: FontWeight.bold),)),
                  const SizedBox(width: 5,),
                  Row(children: [
                    if (sitesManager.isFavorite(site)) const Icon(Icons.favorite, color: Colors.purpleAccent,),
                    if (sitesManager.isFavorite(site)) const SizedBox(width: 5,),
                    if (sitesManager.isVisited(site)) const Icon(Icons.visibility, color: Colors.cyan,),
                    if (sitesManager.isVisited(site)) const SizedBox(width: 5,),
                  ],),
              ],),
              const SizedBox(height: 10,),
              Text(site.englishName, textAlign: TextAlign.left),
              const SizedBox(height: 10,),
              if (site.isOpen != null) TimeIndicatorView(site: site, mainAxisAlignment: MainAxisAlignment.start,) else Text("${site.days}"),
            ],
          ),
        )
    );
  }
  
}