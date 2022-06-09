import 'package:flutter/material.dart';
import '../CulturalSite.dart';
import '../APIService.dart';
import 'SiteListView.dart';


class SitesView extends StatefulWidget {
  const SitesView({Key? key}) : super(key: key);

  @override
  State<SitesView> createState() => _SitesViewState();
}

class _SitesViewState extends State<SitesView> with AutomaticKeepAliveClientMixin<SitesView> {

  late Future<void> _initSite;
  List<CulturalSite> sites = [];

  @override
  void initState() {
    _initSite = _initSites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _initSite,
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            {
              return const Center(
                child: Text('Loading...'),
              );
            }
          case ConnectionState.done:
            {
              return RefreshIndicator(
                onRefresh: _refreshSites,
                child: SiteListView(sites: sites),
              );
            }
        }
      },
    );
  }

  Future<void> _initSites() async {
    final sites = await APIService.fetchCulturalSites(limit: 20);
    this.sites = sites;
  }

  Future<void> _refreshSites() async {
    final sites = await APIService.fetchCulturalSites(limit: 20);
    setState(() {
      this.sites = sites;
    });
  }

  // the mixin is not necessary because of the pageview wrapper in Home.dart
  @override
  bool get wantKeepAlive => true;
}
