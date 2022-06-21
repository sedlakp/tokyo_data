
import 'package:flutter/material.dart';

enum SiteCategory {
  culturalProperty,
  building,
  historicSite,
  archaeology,
  scenicSpot,
  artsAndCrafts,
  historicSite2,
  craftsmanship,
  naturalMonument,
  ancientDocument,
  artsAndCraftsAndMaterials,
  historicalMaterial,
  folkPropertyTangible,
  encyclopedia,
  folkPropertyIntangibleCustoms,
  folkPropertyIntangibleEnt;
  //empty;

  static List<SiteCategory> getSiteCategories({required List<String> kind}) {
    if (kind.isNotEmpty) {
      return kind.map((item) {
        return SiteCategory.values.firstWhere((element) => item == element.name, orElse: () => SiteCategory.culturalProperty);
      },).toList();
    } else {return [];}
  }


  String get name {
    switch (this) {
      case culturalProperty: return "都指定文化財";
      case building: return "建造物";
      case historicSite: return "史跡";
      case archaeology: return "考古資料";
      case scenicSpot: return "名勝";
      case artsAndCrafts: return "美術工芸品";
      case historicSite2: return "旧跡";
      case craftsmanship: return "工芸技術";
      case naturalMonument: return "天然記念物";
      case ancientDocument: return "古文書";
      case artsAndCraftsAndMaterials: return "美術工芸品・考古資料";
      case historicalMaterial: return "歴史資料";
      case folkPropertyTangible: return "有形民俗文化財";
      case encyclopedia: return "典籍";
      case folkPropertyIntangibleCustoms: return "無形民俗文化財（風俗慣習）";
      case folkPropertyIntangibleEnt: return "無形民俗文化財（民俗芸能）";
      //case empty: return "";
      default: return "";
    }
  }

  IconData get icon {
    switch (this) {
      default: return Icons.castle;
    }

  }

  AssetImage get image {
    switch (this) {
      case SiteCategory.craftsmanship: return const AssetImage("assets/sake.jpg");
      default: return const AssetImage("assets/tokyo.jpg");
    }
  }

}