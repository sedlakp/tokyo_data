
import "dart:math";

class TokyoPieItem {
  String name;
  double value;

  TokyoPieItem(this.name,this.value);

  final _random = Random();
  final List<String> _hexes = ["057c89","efbc04","c4ba07","072e60","930b1d","af390a","1f7c08","024277","e81497","037982","e81497","c91496","480187"];

  late String hexColor = "0xff${_hexes[_random.nextInt(_hexes.length)]}";
}