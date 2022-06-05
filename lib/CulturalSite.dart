
class CulturalSite {
  List<String> description;
  List<String> kind;
  String name;
  String kanaName;

  CulturalSite({ required this.description, required this.kind, required this.name, required this.kanaName});

  CulturalSite.fromJson(Map<String, dynamic> json):
              description = json["説明"].cast<String>(),
              kind = json["種別"].cast<String>(),
              name = json["名称"]["表記"][0],
              kanaName = json["名称"]["カナ表記"];

}

// class CulturalSiteList {
//   List<CulturalSite> siteList;
//
//   CulturalSiteList(this.siteList);
//
//   CulturalSiteList.fromJson(List<Map<String,dynamic>> json):
//       sitelist = json;
// }