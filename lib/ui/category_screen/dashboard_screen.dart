
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:tokyo_data/ui/sites_screen/site_cell.dart';
import 'category_list_view.dart';
import '../screens.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final Random _random = Random();

  int _randomInt = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<SitesManager>(builder: (context, manager, child) {
      if (_randomInt == -1) {
        _randomInt = _random.nextInt(manager.sites.length);
      }
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
            children: [
              randomSite(manager),
              categoryGrid(),
            ]),
      );
    },);
  }

  Widget randomSite(SitesManager manager) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Random site", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500)),
              IconButton(onPressed: refreshPressed, icon: const Icon(Icons.refresh),splashRadius: 20,),
            ],
          ),
          GestureDetector(
            onTap: () {
              pushToDetail(context,manager.sites[_randomInt]);
            },
              child: SiteCell(site: manager.sites[_randomInt]
              )),
        ]
    );
  }

  Widget categoryGrid() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          Text("Categories", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16,),
          GridView.builder(
            primary: false,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: SiteCategory.values.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                var siteCategory = SiteCategory.values[index];

                return GestureDetector(
                    onTap: () {
                      _itemTapped(siteCategory);
                    },
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                        child: Stack(
                            children: [
                              Positioned(
                                top:0,left: 0,bottom: 0,right: 0,
                                child: Container(
                                  foregroundDecoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black87,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: [0, 0.5],
                                    ),
                                  ),
                                  child: Image(image: siteCategory.image,fit: BoxFit.cover)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 5,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width/2-40,
                                        child: Text(
                                          maxLines: 3,
                                          siteCategory.name,
                                          style: GoogleFonts.montserrat(fontSize: 16,color: Colors.white),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),//Stack(

                    )
                );
              }),
        ],
      );
  }


  void _itemTapped(SiteCategory category) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return CategoryListView(category: category,);
        },)
    );
  }

  void refreshPressed() {
    setState(() {
      _randomInt = -1;
    });
  }

  void pushToDetail(BuildContext context, CulturalSite site) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return DetailSiteView(site: site,);
        },)
    );
  }
}
