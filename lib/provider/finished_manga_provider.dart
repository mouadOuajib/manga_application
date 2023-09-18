import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/manga.dart';

class FinishedProvider extends ChangeNotifier {
  //watch later
  final List<Manga> _finishedMangas = [];
  List<Manga> get finishedMangas => _finishedMangas;

  void addToFinishMangas(Manga manga) {
    _finishedMangas.add(manga);
    log("this is the list of finished : $_finishedMangas");
    log("title: ${_finishedMangas[0].title}");
    log("title:${manga.title}");
    notifyListeners();
  }

  void removeFromeFinishMangas(Manga manga) {
    _finishedMangas.remove(manga);
    log("this is the list of finished : $_finishedMangas");
    notifyListeners();
  }
}
