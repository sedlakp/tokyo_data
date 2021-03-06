import 'package:flutter/material.dart';
import 'package:tokyo_data/models/models.dart';

class TimeIndicatorView extends StatelessWidget {
  const TimeIndicatorView({Key? key, required this.site, this.mainAxisAlignment = MainAxisAlignment.center}) : super(key: key);

  final CulturalSite site;

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              color: site.isOpen! ? Colors.green : Colors.red,
              shape: BoxShape.circle
          ),
        ),
        const SizedBox(width: 10,),
        Text("${site.open} - ${site.close}", style: Theme.of(context).textTheme.bodySmall,),
        const SizedBox(width: 10,),
        Text("${site.days}", style: Theme.of(context).textTheme.bodySmall,),
      ],
    );
  }
}
