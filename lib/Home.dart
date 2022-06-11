import 'package:flutter/material.dart';
import 'package:tokyo_data/SitesScene/SitesView.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
      name: "/",
      key: ValueKey("/"),
      child: Home(),
    );
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;

  static List<Widget> tabPages = [
    const SitesView(),
    Container(color: Colors.cyanAccent,)

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
        index: _selectedIndex,
        children: tabPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "東京"),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings" ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
