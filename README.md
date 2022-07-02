# tokyo_data

I am using this project to learn Flutter and Dart.

A flutter app to present Tokyo data, for now cultural heritage sites

The google maps api key will probably not work because I restricted it. If it does not work, create your own following [this](https://pub.dev/packages/google_maps_flutter)

## Features ( in progress )
- [x] App states: SplashScreen -> Data load -> Main app  
- [x] Show progress bar while fetching the sites data from API  
    - [ ] Nicer UI  
- [x] Infinite scroll for sites (for now separated from the initial data load)  
- [x] Site detail  
- [x] Map with all sites, map will have a list of sites at the bottom  
    - [ ] Nicer UI  
    - [x] focus map pin when tapped on sites list card  
    - [ ] search to filter sites and remember searches  
    - [ ] add clustering for items  
    - [x] add to favorites  
- [ ] Add SQL database for persistence  
- [ ] App icon  

## Data source
[Tokyo open data portal](https://portal.data.metro.tokyo.lg.jp/opendata-api/)

## Current screenshots (2022/7/2)
|List  |Map  |Detail  |  Stats  |
|----|-----|------|------|
|<img src="/screenshots/list.png" width="200">|<img src="/screenshots/map.png" width="200">|<img src="/screenshots/detail.png" width="200">|<img src="/screenshots/stats.png" width="200">|  
|Dashboard  |Marked  |Loading | 
|<img src="/screenshots/dashboard.png" width="200">|<img src="/screenshots/marked.png" width="200">|<img src="/screenshots/loading.png" width="200">|