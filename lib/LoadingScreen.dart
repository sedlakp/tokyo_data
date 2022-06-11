import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/AppStateManager.dart';

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

  late AnimationController controller;

  @override
  void initState() {
    // TODO: Replace animation with real api request
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      setState(() {}); // update the progress view
    });
    controller.addStatusListener((AnimationStatus status){
      print(status);
      // wait for animation to finish
      if (status == AnimationStatus.completed) {
        Provider.of<AppStateManager>(context, listen: false).dataLoadedFinished();
      }
    });
    controller.forward(); // start animation
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LinearProgressIndicator(
            value: controller.value,

          ),
        ),
      ),
    );
  }
}
