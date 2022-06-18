import 'package:flutter/material.dart';
import 'package:tokyo_data/Screens/DashboardScreen.dart';
import 'package:tokyo_data/Screens/Screens.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/Models/Models.dart';

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
    const DashboardScreen(),
    const MapScreenView(),
    const StatsScreen(),

  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text("東京"),
          //backgroundColor: Colors.black.withAlpha(220),
          shadowColor: Colors.transparent,
      ),
      body: IndexedStack(
        index: widget.currentTab,
        children: tabPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.white.withAlpha(220),
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "東京"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.map),label: "Map" ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats")
        ],
        onTap: (index) {
          Provider.of<AppStateManager>(context, listen: false)
              .goToTab(index);
        },
      ),
    );
  }

}
