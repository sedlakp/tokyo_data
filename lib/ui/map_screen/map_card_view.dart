import 'package:flutter/material.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/Models/custom_colors.dart';
import 'package:tokyo_data/ui/time_indicator_view.dart';
import '../screens.dart';

class MapCardView extends StatefulWidget {
  const MapCardView({Key? key, required this.site, required this.updateMarkerCallback}) : super(key: key);

  final CulturalSite site;
  final Function updateMarkerCallback;

  @override
  State<MapCardView> createState() => _MapCardViewState();
}

class _MapCardViewState extends State<MapCardView> {

  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          color: Colors.white.withAlpha(230),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // todo add rolling animation for long names
                    Text(widget.site.name, softWrap: false, overflow: TextOverflow.fade ,maxLines: 1, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                    const SizedBox(height: 5,),
                    Text(widget.site.kanaName, softWrap: false, overflow: TextOverflow.fade, maxLines: 1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.blueGrey),),
                    const SizedBox(height: 5,),
                    if (widget.site.isOpen != null) TimeIndicatorView(site: widget.site) else Text("${widget.site.days}"),
                    Wrap(spacing: 8,children: getChips(),)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        favoriteBtnTapped(widget.site);
                      },
                      style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: CustomColors.pleasingPink),
                      child: sitesManager.isFavorite(widget.site) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: ElevatedButton(onPressed: () {
                        pushToDetail(context, widget.site);
                      },
                        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                        child: const Icon(Icons.read_more),
                      ),

                    ),
                    ElevatedButton(
                      onPressed: () {
                        visitedBtnTapped(widget.site);
                      },
                      style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: CustomColors.gremlin),
                      child: sitesManager.isVisited(widget.site) ? const Icon(Icons.visibility) :  const Icon(Icons.visibility_outlined),
                    ),
                  ],
                )
              ],
            ),
          ),
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

  void favoriteBtnTapped(CulturalSite site) {
    setState(() {
      sitesManager.handleFavorite(site);
      widget.updateMarkerCallback(site);
    });
  }

  void visitedBtnTapped(CulturalSite site) {
    setState(() {
      sitesManager.handleVisited(site);
      widget.updateMarkerCallback(site);
    });
  }

  List<Chip> getChips(){
    return widget.site.categories.map((e) {
      return Chip(label: Text(e.name, style: Theme.of(context).textTheme.bodySmall,));
    },).toList();
  }

}
