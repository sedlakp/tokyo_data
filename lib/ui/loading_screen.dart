import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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

  List<RotateAnimatedText> get texts {
    var list = ["東京", "千代田", "中央", "港", "新宿", "台東", "渋谷", "豊島"];
    var sitesList = list.map((e) => RotateAnimatedText(e)).toList();
    sitesList.shuffle();
    return sitesList;
  }

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
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 40.0, height: 150.0),
                  Text('Explore'.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 20),),
                  const SizedBox(width: 20.0, height: 150.0),
                  DefaultTextStyle(
                    style: GoogleFonts.kleeOne(fontSize: 40, color: Colors.black),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: texts, //[RotateAnimatedText("東京"), RotateAnimatedText("新宿"), RotateAnimatedText("渋谷") ],
                    ),
                  ),
                ],
              ),
              LinearProgressIndicator(value: progress,),
            ],
          ),
        ),
    );
  }

  void fetchSites() async {
    while (!hasAllData) {
      var batch = await APIService.fetchCulturalSites2(limit: 50, cursor: cursor);
      cursor = batch.cursor;
      //sites.addAll(batch.siteList);
      manager.sites.addAll(batch.siteList.where((element) => element.name.isNotEmpty));
      hasAllData = !batch.hasMoreData;
      print("everything downloaded: $hasAllData, number of items yet: ${manager.sites.length}");
      setState(() {});
    }

    print("push to app");
    stateManager.dataLoadedFinished();

  }
}
