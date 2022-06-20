import 'package:flutter/material.dart';
import 'package:tokyo_data/ui/screens.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/models/models.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.currentTab}) : super(key: key);

  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: "/",
      key: const ValueKey("/"),
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
          title: const Text("Tokyo sites"),
          //backgroundColor: Colors.black.withAlpha(220),
          shadowColor: Colors.transparent,
       // actions: [IconButton(onPressed: showHelp, icon: const Icon(Icons.help_outline))],
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

  void showHelp() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return EmptyScreen(color: Colors.orange);
        },)
    );
  }

}
