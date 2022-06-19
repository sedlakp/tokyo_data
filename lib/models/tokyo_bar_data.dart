
import 'models.dart';

class BarData {

  BarData(this.barTitle, this.bars, {required this.maxValue});

  String barTitle;
  List<BarItem> bars;
  double maxValue;
}