import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';


class EmptyScreen extends StatefulWidget {
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
  State<EmptyScreen> createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  late List<RotateAnimatedText> texts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        backgroundColor: widget.color,
        body: Consumer<SitesManager>(
          builder: (context, sitesManager, child) {

            texts = setupTextList(sitesManager);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 40.0, height: 140.0),
                      Text('Explore'.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 20),),
                      const SizedBox(width: 20.0, height: 140.0),
                      DefaultTextStyle(
                        style: GoogleFonts.kleeOne(fontSize: 40, color: Colors.black),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: texts, //[RotateAnimatedText("東京"), RotateAnimatedText("新宿"), RotateAnimatedText("渋谷") ],
                        ),
                      ),
                    ],
                  ),
                  Text(""),
                ],
              ),
            );
          },
        ),
    );
  }

  List<RotateAnimatedText> setupTextList(SitesManager manager) {
    var list = ["東京", "千代田", "中央", "港", "新宿", "台東", "渋谷", "豊島"];
    var sitesList = list.map((e) => RotateAnimatedText(e)).toList();
    sitesList.shuffle();
    return sitesList;
  }
}
