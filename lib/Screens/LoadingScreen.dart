import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/Models/Models.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
      name: "/loading",
      key: ValueKey("/loading"),
      child: LoadingScreen(),
    );
  }

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin{

  //late AnimationController controller;
  late SitesManager manager = Provider.of<SitesManager>(context, listen: false);
  late AppStateManager stateManager = Provider.of<AppStateManager>(context, listen: false);

  //List<CulturalSite> sites = [];
  String cursor = "";
  bool hasAllData = false;

  double get progress {
    return manager.sites.length/250 <= 1 ? manager.sites.length/250 : 1;
  }

  @override
  void initState() {
    //setupAnimation();
    super.initState();
    fetchSites();
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LinearProgressIndicator(
            value: progress,

          ),
        ),
      ),
    );
  }

  void fetchSites() async {
    while (!hasAllData) {
      var batch = await APIService.fetchCulturalSites2(limit: 50, cursor: cursor);
      cursor = batch.cursor;
      //sites.addAll(batch.siteList);
      manager.sites.addAll(batch.siteList);
      hasAllData = !batch.hasMoreData;
      print("everything downloaded: $hasAllData, number of items yet: ${manager.sites.length}");
      setState(() {});
    }

    Set<String?> days = {};
    for (var site in manager.sites) {
      days.add(site.days);
    }

    for (var item in days) {
      print(item);
    }
    // print("List of categories is:");
    // Set<String> categories = {};
    // for (var site in manager.sites) {
    //   categories.addAll(site.kind);
    // }
    // for (var item in categories) {
    //   print(item);
    // }



    print("push to app");
    stateManager.dataLoadedFinished();

  }

  // void setupAnimation() {
  //   controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 3),
  //   )..addListener(() {
  //     setState(() {}); // update the progress view
  //   });
  //   controller.addStatusListener((AnimationStatus status){
  //     print(status);
  //     // wait for animation to finish
  //     if (status == AnimationStatus.completed) {
  //       Provider.of<AppStateManager>(context, listen: false).dataLoadedFinished();
  //     }
  //   });
  //   controller.forward(); // start animation
  // }
}
