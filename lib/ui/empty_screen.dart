import 'package:flutter/material.dart';


class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key, required this.color}) : super(key: key);

  static MaterialPage page(color) {
    return MaterialPage(
      name: "/splash2",
      key: const ValueKey("/splash2"),
      child: EmptyScreen(color: color),
    );
  }

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        backgroundColor: color,
        body: Center(
          child: Text("Screen with color $color"),
        ),
    );
  }
}
