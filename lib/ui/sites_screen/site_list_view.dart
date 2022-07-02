import 'package:flutter/material.dart';
import 'package:tokyo_data/Models/custom_colors.dart';
import 'package:tokyo_data/ui/screens.dart';
import 'package:tokyo_data/models/models.dart';
import 'site_cell.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class SiteListView extends StatefulWidget {
  const SiteListView({Key? key, required this.sitesManager }): super(key: key);

  final SitesManager sitesManager;

  @override
  State<SiteListView> createState() => _SiteListViewState();
}

class _SiteListViewState extends State<SiteListView> {
  int _currentSelection = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          height: 72,
          width: MediaQuery.of(context).size.width-16,
          child: segmentedControl(),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(top: 2),
                itemCount: _currentSelection == 0 ? widget.sitesManager.favoritedSites.length : widget.sitesManager.visitedSites.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      pushToDetail(context,index);
                    },
                   child: SiteCell(site: _currentSelection == 0 ? widget.sitesManager.favoritedSites[index] : widget.sitesManager.visitedSites[index],),
                  );
                },
              ),
              Container(
                height: 20,
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xfffafafa),
                      Colors.white.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.5],
                  ),
                ),
              )
            ]
          ),
        ),
      ],
    );
  }

  Map<int, Widget> _children() => {
    0: const Icon(Icons.favorite),
    1: const Icon(Icons.visibility),
  };

  Widget segmentedControl() {
    return MaterialSegmentedControl(
      children: _children(),
      selectionIndex: _currentSelection,
      borderColor: CustomColors.italianGrape,
      selectedColor: CustomColors.italianGrape,
      unselectedColor: Colors.white,
      borderRadius: 32.0,
      onSegmentChosen: (int index) {
        setState(() {
          _currentSelection = index;
        });
      },
    );
  }

  void pushToDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return DetailSiteView(site: _currentSelection == 0 ? widget.sitesManager.favoritedSites[index] : widget.sitesManager.visitedSites[index],);
        },)
    );
  }
}