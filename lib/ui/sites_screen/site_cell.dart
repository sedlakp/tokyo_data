import 'package:flutter/material.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/ui/time_indicator_view.dart';

class SiteCell extends StatefulWidget {
  const SiteCell({Key? key, required this.site}) : super(key: key);

  final CulturalSite site;

  @override
  State<SiteCell> createState() => _SiteCellState();
}

class _SiteCellState extends State<SiteCell> {
  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  @override
  Widget build(BuildContext context) {
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
                  Flexible(child: Text(widget.site.name, style: Theme.of(context).textTheme.titleMedium,)),
                  const SizedBox(width: 5,),
                  Row(children: [
                    if (sitesManager.isFavorite(widget.site)) const Icon(Icons.favorite, color: Color(0xffef3054),),
                    if (sitesManager.isFavorite(widget.site)) const SizedBox(width: 5,),
                    if (sitesManager.isVisited(widget.site)) const Icon(Icons.visibility, color: Color(0xffA69658),),
                    if (sitesManager.isVisited(widget.site)) const SizedBox(width: 5,),
                  ],),
                ],),
              const SizedBox(height: 10,),
              Text(widget.site.englishName, style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.left),
              const SizedBox(height: 15,),
              if (widget.site.isOpen != null) TimeIndicatorView(site: widget.site, mainAxisAlignment: MainAxisAlignment.start,)
              else Text("${widget.site.days}",style: Theme.of(context).textTheme.bodySmall,),
            ],
          ),
        )
    );
  }
}
