import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tokyo_data/Models/Models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


class MapScreenView extends StatefulWidget {
  const MapScreenView({Key? key}) : super(key: key);

  @override
  State<MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<MapScreenView> {

  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();


  final Completer<GoogleMapController> _controller = Completer();

  late final CameraPosition _siteLocation = CameraPosition(
    target: LatLng(sitesManager.sites.first.latitude ?? 0, sitesManager.sites.first.longitude ?? 0),
    zoom: 12,
  );

  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _markers.clear();
      for (final site in sitesManager.sites) {
        final marker = Marker(
          markerId: MarkerId(site.name),
          position: LatLng(site.latitude ?? 0, site.longitude ?? 0),
          onTap: () {
            markerTapped(site);
          },
          infoWindow: InfoWindow(
            title: site.name,
            snippet: site.address,
          ),
        );
        _markers[site.name] = marker;
      }

      print(_markers.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          map(),
          Positioned(
            bottom: 10,
            height: 180,
            left: 0,
            right: 0,
            child: sitesList()
          )
        ],
      ),
    );
  }

  void _onSiteTap(int index) async {
    CameraPosition siteLocation = CameraPosition(
      target: LatLng(sitesManager.sites[index].latitude ?? 0, sitesManager.sites[index].longitude ?? 0),
      zoom: 12,
    );
    print(siteLocation.target);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(siteLocation));
  }

  Future<void> _resetPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_siteLocation));
  }

  Widget map() {
    return GoogleMap(
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      initialCameraPosition: _siteLocation,
      markers: _markers.values.toSet(),
    );
  }

  Widget sitesList() {
    return ScrollablePositionedList.builder(
      //physics: const PageScrollPhysics(),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      scrollDirection: Axis.horizontal,
      itemCount: sitesManager.sites.length,
      itemBuilder: (context, index) {
        var currentSite = sitesManager.sites[index];
        return GestureDetector(
          onTap: () { _onSiteTap(index); },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              child: Column(
                children: [
                  Text(currentSite.englishName),
                  Row(
                    children: [
                      IconButton(onPressed: () {
                          favoriteBtnTapped(currentSite);
                        },
                        icon: sitesManager.isFavorite(currentSite) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline),
                      ),
                      IconButton(onPressed: () {
                        visitedBtnTapped(currentSite);
                        },
                          icon: sitesManager.isVisited(currentSite) ? const Icon(Icons.visibility) :  const Icon(Icons.visibility_outlined),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },

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

  void markerTapped(CulturalSite site) {
    // scroll to the item and focus it
    int siteIndex = sitesManager.sites.indexOf(site);
    itemScrollController.scrollTo(
        index: siteIndex,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubic);
  }
}
