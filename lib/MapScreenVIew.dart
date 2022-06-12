import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/SitesManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


class MapScreenView extends StatefulWidget {
  const MapScreenView({Key? key}) : super(key: key);

  @override
  State<MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<MapScreenView> {

  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

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
            height: 120,
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
    return ListView.builder(
      //physics: const PageScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: sitesManager.sites.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () { _onSiteTap(index); },
          child: SizedBox(
            width: 250,
            child: Card(
              child: Text(sitesManager.sites[index].englishName),
            ),
          ),
        );
      },

    );
  }

}
