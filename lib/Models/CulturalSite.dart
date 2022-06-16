
import 'package:tokyo_data/Models/Models.dart';
import 'package:intl/intl.dart';

class CulturalSite {

  String siteId;
  List<String> description;
  List<String> kind;
  String name;
  String englishName;
  String kanaName;

  double? latitude;
  double? longitude;
  String? address;

  String? open;
  String? close;
  String? days;

  late final categories = SiteCategory.getSiteCategories(kind: kind);

  bool? get isOpen {
    if ((_openTodayWeekDay == null) || (_checkIsTimeOpen == null)) {
      return null;
    }
    return _openTodayWeekDay! && _checkIsTimeOpen!;
  }

  bool? get _checkIsTimeOpen {
    if (open == "0:00" && close == "0:00") {
        return null;
    }

    var now = DateTime.now();
    //var time = DateFormat('HH:mm');
    if ((open ?? "").isNotEmpty && (close ?? "").isNotEmpty) {
      var op = open!.split(":").map((e) => int.parse(e),);
      var en = close!.split(":").map((e) => int.parse(e));

      var n = now.hour*60+now.minute;
      var o = op.first*60+op.last;
      var e = en.first*60+en.last;

      return (n<e) && (n>o);
    }
    return null;
  }

  bool? get _openTodayWeekDay {
    var now = DateTime.now();
    var day = now.weekday;
    String dayJp;
    switch (day) {
      case 1: dayJp = "月";
      break;
      case 2: dayJp = "火";
      break;
      case 3: dayJp = "水";
      break;
      case 4: dayJp = "木";
      break;
      case 5: dayJp = "金";
      break;
      case 6: dayJp = "土";
      break;
      default: dayJp = "日";
    }

    if (days == "利用可能曜日特記事項のとおり" || days == "") {
      return null;
    }

    if ((days ?? "").contains(dayJp)) {
      return true;
    } else {
      return false;
    }
  }

  CulturalSite({
    required this.siteId,
    required this.description,
    required this.kind,
    required this.name,
    required this.englishName,
    required this.kanaName,
    this.latitude,
    this.longitude,
    this.address,
    this.open,
    this.close,
    this.days,
  });

  CulturalSite.fromJson(Map<String, dynamic> json):
              siteId = json["ID"] as String,
              description = json["説明"].cast<String>(),
              kind = json["種別"].cast<String>(),
              name = json["名称"]["表記"][0],
              englishName = json["名称"]["表記"][1],
              kanaName = json["名称"]["カナ表記"],
              latitude = double.tryParse(json["設置地点"]["地理座標"]["緯度"] as String),
              longitude = double.tryParse(json["設置地点"]["地理座標"]["経度"] as String),
              address = json["設置地点"]["住所"]["表記"] as String?,
              open = json["設置地点"]["利用可能時間"]["開始時間"] as String?,
              close = json["設置地点"]["利用可能時間"]["終了時間"] as String?,
              days = json["設置地点"]["利用可能時間"]["開催期日"] as String?;

}

class CulturalSiteList {
  List<CulturalSite> siteList;
  String cursor;
  bool hasMoreData;

  CulturalSiteList(this.siteList, this.cursor, this.hasMoreData);

  CulturalSiteList.fromJson(List<dynamic> json):
      cursor = json[1]["endCursor"],
      hasMoreData = (json[1]["moreResults"] as String) != "NO_MORE_RESULTS",
      siteList = List<CulturalSite>.from(json[0].map((model)=> CulturalSite.fromJson(model)));
}