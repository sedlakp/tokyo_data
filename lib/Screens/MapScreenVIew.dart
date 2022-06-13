import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tokyo_data/Models/Models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'Screens.dart';


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
    return Scaffold(
      body: Stack(
        children: [
          map(),
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
          onTap: () { _onSiteTap(index); },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              color: Colors.white.withAlpha(230),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(currentSite.name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                        Text(currentSite.kanaName, style: TextStyle(fontSize: 11, color: Colors.blueGrey),),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () {
                            favoriteBtnTapped(currentSite);
                          },
                          color: Colors.purpleAccent,
                          icon: sitesManager.isFavorite(currentSite) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: ElevatedButton(onPressed: () {
                              pushToDetail(context, currentSite);
                            },
                              child: Icon(Icons.read_more),
                              style: ElevatedButton.styleFrom(shape: CircleBorder()),
                            ),

                        ),
                        IconButton(onPressed: () {
                          visitedBtnTapped(currentSite);
                          },
                            color: Colors.cyan,
                            icon: sitesManager.isVisited(currentSite) ? const Icon(Icons.visibility) :  const Icon(Icons.visibility_outlined),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
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

  Future<void> _resetPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(firstSiteLocation));
  }

  void favoriteBtnTapped(CulturalSite site) {
    setState(() {
      sitesManager.handleFavorite(site);
      _updateMarker(site);
    });
  }

  void visitedBtnTapped(CulturalSite site) {
    setState(() {
      sitesManager.handleVisited(site);
      _updateMarker(site);
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

  void _updateMarker(CulturalSite site) {
    _markers[site.siteId] = createMarker(site);
  }

  void pushToDetail(BuildContext context, CulturalSite site) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return DetailSiteView(site: site,);
        },)
    );
  }

  // MARK: - Setup methods

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    print("SETTING UP THE MAP");
    setState(() {
      _markers.clear();
      for (final site in sitesManager.sites) {
        _markers[site.siteId] = createMarker(site);
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
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
    } else if (isVisited) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    } else {
      return BitmapDescriptor.defaultMarker;
    }
  }
}
