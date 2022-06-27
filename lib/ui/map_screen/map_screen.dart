import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tokyo_data/Models/custom_colors.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tokyo_data/ui/search_bar_view.dart';
import 'map_card_view.dart';
import 'dart:async';


class MapScreenView extends StatefulWidget {
  const MapScreenView({Key? key}) : super(key: key);

  @override
  State<MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<MapScreenView> {

  // MARK: - variables

  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  final Completer<GoogleMapController> _controller = Completer();

  late final CameraPosition firstSiteLocation = CameraPosition(
    target: LatLng(sitesManager.sites.first.latitude ?? 0, sitesManager.sites.first.longitude ?? 0),
    zoom: 12,
  );

  final Map<String, Marker> _markers = {};

  // MARK: - Build UI methods

  @override
  Widget build(BuildContext context) {
    // consumer to update state when site value like favorite or visited changes
    return Consumer<SitesManager>(builder: (context, _, child) {
      updateMap();
      return Scaffold(
        body: Stack(
          children: [
            map(),
            Positioned(
              top: 110,
              left: 60,
              right: 60,
              child: SearchBarView(textChanged: onTextChanged,),
            ),
            Positioned(
                top: 100,
                right: 8,
                child: IconButton(iconSize: 38, onPressed: questionPressed,icon: const Icon(Icons.info_outline, color: Color(0xff3a3e45),),)),
            Positioned(
                bottom: 10,
                height: 200,
                left: 0,
                right: 0,
                child: sitesList()
            )
          ],
        ),
      );
    },
    );
  }

  Widget map() {
    return GoogleMap(
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: _onMapCreated,
      initialCameraPosition: firstSiteLocation,
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
            onTap: () {
              _onSiteTap(index);
            },
            child: MapCardView(site: currentSite, updateMarkerCallback: _updateMarker,));
      },

    );
  }

  // MARK: -  Action methods
  void _onSiteTap(int index) async {
    CameraPosition siteLocation = CameraPosition(
      target: LatLng(sitesManager.sites[index].latitude ?? 0, sitesManager.sites[index].longitude ?? 0),
      zoom: 12,
    );
    print(siteLocation.target);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(siteLocation));
  }

  // Future<void> _resetPosition() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(firstSiteLocation));
  // }

  void markerTapped(CulturalSite site) {
    // scroll to the item and focus it
    int siteIndex = sitesManager.sites.indexOf(site);
    itemScrollController.scrollTo(
        index: siteIndex,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubic);
  }

  void _updateMarker(CulturalSite site) {
    _markers[site.siteId] = createMarker(site);
  }

  void updateMap() {
    if (sitesManager.sitesWaitingForMapUpdate.isEmpty) { return; }
    print("Update map with marker");
    for (var site in sitesManager.sitesWaitingForMapUpdate) {
      _updateMarker(site);
    }
    sitesManager.clearWaitingForMapUpdate();
  }

  // MARK: - Setup methods

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    print("SETTING UP THE MAP");
    setState(() {
      _markers.clear();
      for (final site in sitesManager.sites) {
        _updateMarker(site);
      }

      print(_markers.length);
    });
  }

  Marker createMarker(CulturalSite site) {
    return Marker(
      icon: setMapIcon(site),
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
  }

  BitmapDescriptor setMapIcon(CulturalSite site) {
    bool isFavorite = sitesManager.isFavorite(site);
    bool isVisited = sitesManager.isVisited(site);
    // give preference to favorite
    if (isFavorite) {
      return BitmapDescriptor.defaultMarkerWithHue(342);
    } else if (isVisited) {
      return BitmapDescriptor.defaultMarkerWithHue(36);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(195);
    }
  }

  void questionPressed() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Map info'),
        content: const Text('Some sites share the same location, tapping more than one time on a map pin might reveal a different site.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void onTextChanged(String text) {
    // TODO filter list of sites, also reload the markers on map?
  }


}
