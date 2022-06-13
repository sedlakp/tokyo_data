
class CulturalSite {
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

  CulturalSite({
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