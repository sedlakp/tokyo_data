import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tokyo_data/Models/Models.dart';
import 'package:collection/collection.dart';
import 'package:google_fonts/google_fonts.dart';

class TokyoBarGraph extends StatefulWidget {
  const TokyoBarGraph({Key? key, required this.barData, required this.barWidth}) : super(key: key);

  final BarData barData;
  final double barWidth;

  @override
  State<TokyoBarGraph> createState() => _TokyoBarGraphState();
}

class _TokyoBarGraphState extends State<TokyoBarGraph> {

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(widget.barData.barTitle,style: Theme.of(context).textTheme.headlineLarge,),
              SizedBox(height: 20,),
              Expanded(child: BarChart(mainBarData())),
            ],
          ),
        ),
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: getToolTipData(),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 0.5,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(show: false,),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  BarTouchTooltipData getToolTipData() {
    return BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          var item = widget.barData.bars[group.x.toInt()];
          return BarTooltipItem(
            "${item.desc} ${item.value.toInt()}/${widget.barData.maxValue.toInt()}",
            GoogleFonts.montserrat(
              fontSize: 11.0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          );
        });
  }

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: widget.barData.bars[value.toInt()].xTitle,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == widget.barData.maxValue/2) {
      text = '${widget.barData.maxValue~/2}';
    } else if (value == widget.barData.maxValue) {
      text = '${widget.barData.maxValue.toInt()}';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> showingGroups() {
    return widget.barData.bars.mapIndexed((index, element) {
      return makeGroupData(index, element.value, isTouched: index == touchedIndex, width: widget.barWidth);
    },).toList();
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = const Color(0xff3a3e45),
        double width = 20,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Color(0xff3a3e45), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: widget.barData.maxValue,
            color: Colors.blueGrey,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
