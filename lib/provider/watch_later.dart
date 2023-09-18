import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/manga.dart';

class WatchLaterProvider extends ChangeNotifier {
  //watch later
  final List<Manga> _watchLaterList = [];
  List<Manga> get watchLaterList => _watchLaterList;

  void addToWatchLater(Manga manga) {
    _watchLaterList.add(manga);
    log("this is the list of watch later : $_watchLaterList");
    log("manga link : ${manga.mangaLink}");
    // log("""title: ${_watchLaterList[0].chaptersMap![0]['title']}""");
    // log("title:${manga.chaptersMap![1]['title']}");
    notifyListeners();
  }

  void removeFromWatchLater(Manga manga) {
    _watchLaterList.remove(manga);
    log("this is the list of watch later : $_watchLaterList");
    notifyListeners();
  }

  //
}
