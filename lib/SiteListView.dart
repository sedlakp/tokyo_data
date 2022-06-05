import 'package:flutter/material.dart';
import 'CulturalSite.dart';

class SiteListView extends StatelessWidget {
  const SiteListView({Key? key, required this.sites}) : super(key: key);

  final List<CulturalSite> sites;

  static const test = [1,2,3,4,5,6,7,8];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sites.length,
      itemBuilder: (context, index) {
        return Card(
          child:ListTile(
            title: Text(sites[index].name),
            subtitle: Text(sites[index].description.first),
          ),

        );
      },
    );
  }
}