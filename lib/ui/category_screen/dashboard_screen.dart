
import 'package:flutter/material.dart';
import 'package:tokyo_data/models/models.dart';
import 'category_list_view.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GridView.builder(
          itemCount: SiteCategory.values.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            var siteCategory = SiteCategory.values[index];

            return GestureDetector(
                onTap: () {
                  _itemTapped(siteCategory);
                },
                child: Card(child: Center(child: Text(siteCategory.name, style: Theme.of(context).textTheme.headlineMedium,),))
            );
          }),
    );
  }


  void _itemTapped(SiteCategory category) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return CategoryListView(category: category,);
        },)
    );
  }
}
