import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:tokyo_data/ui/time_indicator_view.dart';
import 'package:tokyo_data/models/custom_colors.dart';
import 'package:url_launcher/url_launcher.dart';


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
    icon: BitmapDescriptor.defaultMarkerWithHue(195),
    markerId: MarkerId(widget.site.name),
    position: LatLng(widget.site.latitude ?? 0, widget.site.longitude ?? 0),
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
          title: const Text("")
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20,),
              Text(widget.site.name, style: Theme.of(context).textTheme.headlineLarge,textAlign: TextAlign.center),
              Text(widget.site.kanaName, style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center),
              Text(widget.site.address ?? "",textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium ,),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: getChips(),
              ),
              const SizedBox(height: 10,),
              if (widget.site.latitude != null && widget.site.longitude != null) setupMap(),
              const SizedBox(height: 10,),
              setupEnglishText(),
              const SizedBox(height: 10,),
              buttons(),
              const SizedBox(height: 10,),
              if (widget.site.isOpen != null) TimeIndicatorView(site: widget.site) else Text("${widget.site.days}", textAlign: TextAlign.center),
              const SizedBox(height: 20,),
              //Text(widget.site.description.first, style: Theme.of(context).textTheme.bodyMedium,),
              Html(
                data: widget.site.description.first,
                style: {
                  "body": Style(
                    fontFamily:"Meiryo",//"Hiragino Kaku Gothic Pro",
                    fontSize: FontSize(14),
                    //padding: EdgeInsets.all(6),
                  ),
                },
                onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                  print("tapped on $url");
                  _launchUrl(url!);
                },
              ),
              const SizedBox(height: 30,),
          ],),

      )
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri,mode: LaunchMode.externalApplication)) throw 'Could not launch $uri';
  }

  List<Chip> getChips(){
    return widget.site.categories.map((e) {
      return Chip(label: Text(e.name));
    },).toList();
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
        ElevatedButton(
          onPressed: () {
            favoriteBtnTapped(widget.site);
          },
          style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: CustomColors.pleasingPink,),
          child: sitesManager.isFavorite(widget.site) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline),
        ),
        const SizedBox(width: 40,),
        ElevatedButton(
          onPressed: () {
            visitedBtnTapped(widget.site);
          },
          style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: CustomColors.gremlin),
          child: sitesManager.isVisited(widget.site) ? const Icon(Icons.visibility) :  const Icon(Icons.visibility_outlined),
        ),
      ],
    );
  }

  Widget setupMap() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
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
              child: ElevatedButton(onPressed: _resetPosition,child: const Icon(Icons.pin_drop),)
          )
        ]),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
