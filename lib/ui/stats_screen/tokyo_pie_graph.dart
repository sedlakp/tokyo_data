import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:provider/provider.dart';
import 'indicator_view.dart';


class TokyoPieGraph extends StatefulWidget {

  final List<TokyoPieItem> items;
  final String pieName;

  const TokyoPieGraph({Key? key, required this.pieName,required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TokyoPieGraphState();
}

class _TokyoPieGraphState extends State<TokyoPieGraph> {

  int touchedIndex = -1;
  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 440,
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(widget.pieName,style: Theme.of(context).textTheme.headlineLarge,),
                const SizedBox(height: 20,),
                Expanded(
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 20,
                          sections: showingSections()),
                    ),

                ),
                const SizedBox(height: 20,),
                getLegend(),
              ],
            ),
          ),
        ),
    );
  }

  List<Indicator> getIndicators() {
    return widget.items.mapIndexed((index, item) {
      return Indicator(
        color: Color(int.parse(item.hexColor)),
        text: item.name,
        isSquare: false,
        size: 16,
        textColor: touchedIndex == index ? Colors.black : Colors.grey,
      );

    },).toList();
  }

  Widget getLegend() {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      //mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.end,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: getIndicators()
    );
  }


  List<PieChartSectionData> showingSections() {
    return widget.items.mapIndexed((index, item) {

        final isTouched = index == touchedIndex;
        final fontSize = isTouched ? 16.0 : 11.0;
        final radius = isTouched ? 90.0 : 80.0;

        return PieChartSectionData(
          color: Color(int.parse(item.hexColor)),
          value: item.value,
          title: "${item.value.toInt()}",
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );

      },).toList();
  }
}