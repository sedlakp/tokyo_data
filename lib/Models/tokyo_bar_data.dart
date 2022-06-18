import 'package:flutter/material.dart';


class BarItem {

  BarItem( this.xTitle,this.value, this.desc);
  Widget xTitle;
  double value;
  String desc = "";
}

class BarData {

  BarData(this.barTitle, this.bars, {required this.maxValue});

  String barTitle;
  List<BarItem> bars;
  double maxValue;
}