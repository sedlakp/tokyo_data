import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tokyo_data/models/models.dart';
import 'package:provider/provider.dart';
import "dart:math";
import 'indicator_view.dart';

class TokyoPieGraph extends StatefulWidget {
  const TokyoPieGraph({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {

  int touchedIndex = -1;
  late final SitesManager sitesManager = Provider.of<SitesManager>(context,listen: false);

  List<String> hexes = ["057c89","efbc04","c4ba07","072e60","930b1d","af390a","1f7c08","024277","e81497","037982","e81497","c91496","480187"];
  final _random = Random();

  late var shuffledHexes = [for (var i = 1; i <= SiteCategory.values.length; i++) hexes[_random.nextInt(hexes.length)]];

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
                Text("Site Categories",style: Theme.of(context).textTheme.headlineLarge,),
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
    return SiteCategory.values.mapIndexed((index, cat) {
      String hex = "0xff${shuffledHexes[index]}";
      return Indicator(
        color: Color(int.parse(hex)),
        text: cat.name,
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
    return SiteCategory.values.mapIndexed((index, cat) {
        var sites = sitesManager.sites.where((element) => element.categories.contains(cat)).toList();

        final isTouched = index == touchedIndex;
        final fontSize = isTouched ? 16.0 : 11.0;
        final radius = isTouched ? 90.0 : 80.0;
        String hex = "0xff${shuffledHexes[index]}";

        return PieChartSectionData(
          color: Color(int.parse(hex)),
          value: 20,
          title: "${sites.length}",
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        );

      },).toList();
  }
}