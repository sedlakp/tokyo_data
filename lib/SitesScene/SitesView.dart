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

  late final Future<void> _initSite;
  List<CulturalSite> sites = [];
  String? _currentCursor = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => showAlert(context));
    _initSite = _initSites();
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
                child: SiteListView(sites: sites, onGetNextPage: onNextPage),
              );
            }
        }
      },
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("List is an infinite scroll, data are separated from previously loaded data, these are used in the Map tab"),
        ));
  }

  Future<void> _initSites() async {
    final sites = await APIService.fetchCulturalSites2();
    this.sites = sites.siteList;
    _currentCursor = sites.cursor;
  }

  Future<void> _refreshSites() async {
    _currentCursor = "";
    final sites = await APIService.fetchCulturalSites2();
    setState(() {
      this.sites = sites.siteList;
      _currentCursor = sites.cursor;
    });
  }

  Future<void> _nextPageSites() async {
    final sites = await APIService.fetchCulturalSites2(cursor: _currentCursor);
    setState(() {
      this.sites.addAll(sites.siteList);
      _currentCursor = sites.cursor;
    });
  }

  void onNextPage() async {
    print("next page load");
    await _nextPageSites();
  }

  // I need the mixin even though i have the pageview wrapper in Home.dart
  @override
  bool get wantKeepAlive => true;
}
