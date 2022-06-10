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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration:BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(8)),
                    child: Text(site.days ?? "",style: const TextStyle(color: Colors.white),)
                  )
              ],),
              const SizedBox(height: 10,),
              Text(site.englishName, textAlign: TextAlign.left),
            ],
          ),
        )
    );
  }
}