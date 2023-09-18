import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/manga.dart';

class CurrentReadingProvider extends ChangeNotifier {
  //watch later
  final List<Manga> _currentReadingList = [];
  List<Manga> get currentReadingList => _currentReadingList;

  void addToCurrentReading(Manga manga) {
    _currentReadingList.add(manga);
    log("this is the list of currentReading : $_currentReadingList");
    log("title: ${_currentReadingList[0].title}");
    log("title:${manga.title}");
    notifyListeners();
  }

  void removeFromeCurrentReading(Manga manga) {
    _currentReadingList.remove(manga);
    log("this is the list of current reading: $_currentReadingList");
    notifyListeners();
  }

  //
}
