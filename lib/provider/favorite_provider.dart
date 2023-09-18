import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/manga.dart';

class FavoriteProvider extends ChangeNotifier {
  //favorite
  final List<Manga> _favoriteList = [];
  List<Manga> get favoriteList => _favoriteList;

  void addToFavorite(Manga manga) {
    _favoriteList.add(manga);
    log("this is the list of favorite: $_favoriteList");
    log("title: ${_favoriteList[0].title}");
    log("title:${manga.title}");
    notifyListeners();
  }

  void removeFromeFavorite(Manga manga) {
    _favoriteList.remove(manga);
    log("this is the list of favorite: $_favoriteList");
    notifyListeners();
  }

  //
}
