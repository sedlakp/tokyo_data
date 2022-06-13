import 'package:shared_preferences/shared_preferences.dart';

import 'Models.dart';
import 'package:flutter/material.dart';

class SitesManager extends ChangeNotifier {

  static const String visitedSitesKey = "visitedSites";
  static const String favoritedSitesKey = "favoritedSites";

  SitesManager() {
    _getFavoritedSitesIDs();
    _getVisitedSitesIDs();
  }

  List<CulturalSite> sites = [];

  List<String> _visitedSitesIDs = [];
  List<String> _favoritedSitesIDs = [];

  List<CulturalSite> get visitedSites {
    return sites.where( (site) {
      return _visitedSitesIDs.contains(site.siteId);
    }).toList();
  }

  List<CulturalSite> get favoritedSites {
    return sites.where((site) {
      return _favoritedSitesIDs.contains(site.siteId);
    },).toList();
  }

  bool isFavorite(CulturalSite site) {
    return _favoritedSitesIDs.contains(site.siteId);
  }

  bool isVisited(CulturalSite site) {
    return _visitedSitesIDs.contains(site.siteId);
  }

  void handleFavorite(CulturalSite site) {
    isFavorite(site) ? removeFavoriteSite(site) : addFavoriteSite(site);
  }

  void handleVisited(CulturalSite site) {
    isVisited(site) ? removeVisitedSite(site) : addVisitedSite(site);
  }

  void addVisitedSite(CulturalSite site) {
    _visitedSitesIDs.add(site.siteId);
    _saveVisitedSitesIDs();
  }

  void addFavoriteSite(CulturalSite site) {
    _favoritedSitesIDs.add(site.siteId);
    _saveFavoritedSitesIDs();
  }

  void removeVisitedSite(CulturalSite site) {
    _visitedSitesIDs.removeWhere((id) {
      return id == site.siteId;
    },);
    _saveVisitedSitesIDs();
  }

  void removeFavoriteSite(CulturalSite site) {
    _favoritedSitesIDs.removeWhere((id) {
      return id == site.siteId;
    },);
    _saveFavoritedSitesIDs();
  }

  void _getVisitedSitesIDs() async {
    final prefs = await SharedPreferences.getInstance();
    _visitedSitesIDs = prefs.getStringList(visitedSitesKey) ?? [];
  }

  void _getFavoritedSitesIDs() async {
    final prefs = await SharedPreferences.getInstance();
    _favoritedSitesIDs = prefs.getStringList(favoritedSitesKey) ?? [];
  }

  void _saveVisitedSitesIDs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(visitedSitesKey, _visitedSitesIDs);
  }

  void _saveFavoritedSitesIDs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(favoritedSitesKey, _favoritedSitesIDs);
  }

}