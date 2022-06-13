import 'package:flutter/material.dart';
import 'package:tokyo_data/Models/Models.dart';
import 'SiteListView.dart';
import 'package:provider/provider.dart';


class SitesView extends StatefulWidget {
  const SitesView({Key? key}) : super(key: key);

  @override
  State<SitesView> createState() => _SitesViewState();
}

class _SitesViewState extends State<SitesView> with ChangeNotifier{

  @override
  Widget build(BuildContext context) {

    return Consumer<SitesManager>(
      builder: (context, manager, child) {
        if (manager.ticker) {
          print("tick");
        } else {
          print("tack");
        }
        return SiteListView(sitesManager: manager,);
      },);
  }

}
