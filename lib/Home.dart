import 'package:flutter/material.dart';
import 'package:tokyo_data/SitesScene/SitesView.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  late PageController _controller;

  static List<Widget> tabPages = [
    const SitesView(),
    Container(color: Colors.cyanAccent,)

  ];

  @override
  void initState() {
    super.initState();
    // the controller and keep page prevents future to trigger on tab change
    _controller = PageController(initialPage: _selectedIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("東京")
      ),
      body: PageView(
        controller: _controller,
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
      _controller.jumpToPage(index);
    });
  }

}
