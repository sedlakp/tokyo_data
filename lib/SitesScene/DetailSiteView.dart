import 'package:flutter/material.dart';
import 'package:tokyo_data/CulturalSite.dart';


class DetailSiteView extends StatefulWidget {

  final CulturalSite site;

  const DetailSiteView({Key? key, required this.site}) : super(key: key);

  @override
  State<DetailSiteView> createState() => _DetailSiteViewState();
}

class _DetailSiteViewState extends State<DetailSiteView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Detail")
      ),
      body: Text(widget.site.kanaName),
    );
  }
}
