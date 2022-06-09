import 'package:flutter/material.dart';
import 'package:tokyo_data/CulturalSite.dart';


class DetailSiteView extends StatefulWidget {

  final CulturalSite site;

  const DetailSiteView({Key? key, required this.site}) : super(key: key);

  @override
  State<DetailSiteView> createState() => _DetailSiteViewState();
}

class _DetailSiteViewState extends State<DetailSiteView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.site.name)
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(widget.site.name, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Text(widget.site.kanaName, style: const TextStyle(fontSize: 11, color: Colors.blueGrey),),
              Text(widget.site.address ?? ""),
              const SizedBox(height: 10,),
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: Colors.blueGrey,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 5,
                        //offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(widget.site.days ?? "", style: const TextStyle(fontSize: 10, color: Colors.white),)

              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.cyan,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 5,
                        //offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("English", style: TextStyle(fontSize: 11, color: Colors.white)),
                      Text(widget.site.englishName),
                    ]
                ),
              ),
              const SizedBox(height: 20,),
              Text(widget.site.description.first),

          ],),
        ),
      )
    );
  }
}
