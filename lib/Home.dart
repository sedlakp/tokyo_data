import 'package:flutter/material.dart';
import 'package:tokyo_data/MapScreenVIew.dart';
import 'package:tokyo_data/SitesScene/SitesView.dart';
import 'package:provider/provider.dart';
import 'AppStateManager.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.currentTab}) : super(key: key);

  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: "/",
      key: ValueKey("/"),
      child: Home(currentTab: currentTab,),
    );
  }

  final int currentTab;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static List<Widget> tabPages = [
    const SitesView(),
    //Container(color: Colors.cyanAccent,)
    const MapScreenView(),

  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("東京")
      ),
      body: IndexedStack(
        index: widget.currentTab,
        children: tabPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "東京"),
          BottomNavigationBarItem(icon: Icon(Icons.map),label: "Map" ),
        ],
        onTap: (index) {
          Provider.of<AppStateManager>(context, listen: false)
              .goToTab(index);
        },
      ),
    );
  }

}
