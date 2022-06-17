import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tokyo_data/Models/Models.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:provider/provider.dart';


class DetailSiteView extends StatefulWidget {

  final CulturalSite site;

  const DetailSiteView({Key? key, required this.site}) : super(key: key);

  @override
  State<DetailSiteView> createState() => _DetailSiteViewState();
}

class _DetailSiteViewState extends State<DetailSiteView> {

  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  final Completer<GoogleMapController> _controller = Completer();

  late final CameraPosition _siteLocation = CameraPosition(
    target: LatLng(widget.site.latitude ?? 0, widget.site.longitude ?? 0),
    zoom: 12,
  );

  late final Marker marker = Marker(
    markerId: MarkerId(widget.site.name),
    position: LatLng(widget.site.latitude!, widget.site.longitude!),
    infoWindow: InfoWindow(
      title: widget.site.name,
      snippet: widget.site.address,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.site.latitude);
    print(widget.site.longitude);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.site.days ?? "")
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            children: [
              Text(widget.site.name, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
              Text(widget.site.kanaName, style: const TextStyle(fontSize: 11, color: Colors.blueGrey),textAlign: TextAlign.center),
              Text(widget.site.address ?? "",textAlign: TextAlign.center),
              setupMap(),
              const SizedBox(height: 10,),
              setupEnglishText(),
              const SizedBox(height: 20,),
              buttons(),
              const SizedBox(height: 20,),
              Text(widget.site.description.first),
              const SizedBox(height: 30,),
          ],),

      )
    );
  }

  void favoriteBtnTapped(CulturalSite site) {
    setState(() {
      sitesManager.handleFavorite(site);
    });
  }

  void visitedBtnTapped(CulturalSite site) {
    setState(() {
      sitesManager.handleVisited(site);
    });
  }

  Widget buttons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {
          favoriteBtnTapped(widget.site);
        },
          color: Colors.purpleAccent,
          icon: sitesManager.isFavorite(widget.site) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline),
        ),
        const SizedBox(width: 40,),
        IconButton(onPressed: () {
          visitedBtnTapped(widget.site);
        },
          color: Colors.cyan,
          icon: sitesManager.isVisited(widget.site) ? const Icon(Icons.visibility) :  const Icon(Icons.visibility_outlined),
        )
      ],
    );
  }

  Widget setupMap() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          GoogleMap(
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: _siteLocation,
            markers: {marker},
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
              ),
            },
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(child: const Icon(Icons.pin_drop),onPressed: _resetPosition,)
          )
        ]),
    );
  }

  Widget setupEnglishText() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueGrey,
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 1,
            blurRadius: 5,
            //offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("English", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(widget.site.englishName, style: const TextStyle(color: Colors.white)),
          ]
      ),
    );
  }


  Future<void> _resetPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_siteLocation));
  }
}
