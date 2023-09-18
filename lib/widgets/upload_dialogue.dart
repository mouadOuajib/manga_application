import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangago/provider/current_reading_provider.dart';
import 'package:mangago/provider/favorite_provider.dart';
import 'package:mangago/provider/finished_manga_provider.dart';
import 'package:provider/provider.dart';

import '../models/manga.dart';

class UplaodDialog extends StatefulWidget {
  final Manga manga;
  const UplaodDialog({Key? key, required this.manga}) : super(key: key);

  @override
  State<UplaodDialog> createState() => _UplaodDialogState();
}

class _UplaodDialogState extends State<UplaodDialog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: SizedBox(
        height: size.height * 0.3,
        width: size.width * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) {
              return ListTile(
                onTap: () {
                  log("manga info:${widget.manga}");
                  if (widget.manga.isAddedToFavorite == false) {
                    favoriteProvider.addToFavorite(Manga(
                      title: widget.manga.title,
                      coverImageUrl: widget.manga.coverImageUrl,
                    ));
                  } else {
                    log("remove");
                    favoriteProvider.removeFromeFavorite(widget.manga);
                  }
                  if (widget.manga.isAddedToFavorite == true) {
                    widget.manga.isAddedToFavorite = false;
                  } else {
                    widget.manga.isAddedToFavorite = true;
                  }
                  log(widget.manga.isAddedToFavorite.toString());
                },
                leading: !widget.manga.isAddedToFavorite!
                    ? const Text("Add To 'Favorite'    😍")
                    : const Text("Remove Frome 'Favorite'    😍"),
                contentPadding: EdgeInsets.symmetric(vertical: 5.h),
              );
            }),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            Consumer<CurrentReadingProvider>(
                builder: (context, currentProvider, child) {
              return ListTile(
                onTap: () {
                  log("manga info:${widget.manga}");
                  if (widget.manga.isAddedToCurrentRead == false) {
                    currentProvider.addToCurrentReading(Manga(
                      mangaLink: widget.manga.mangaLink,
                      title: widget.manga.title,
                      coverImageUrl: widget.manga.coverImageUrl,
                    ));
                  } else {
                    currentProvider.removeFromeCurrentReading(widget.manga);
                  }
                  if (widget.manga.isAddedToCurrentRead == true) {
                    widget.manga.isAddedToCurrentRead = false;
                  } else {
                    widget.manga.isAddedToCurrentRead = true;
                  }
                  log(widget.manga.isAddedToCurrentRead.toString());
                },
                leading: !widget.manga.isAddedToCurrentRead!
                    ? const Text("Add To 'Current Read'    😄")
                    : const Text("Remove Frome 'Current Read'    😄"),
                contentPadding: EdgeInsets.symmetric(vertical: 5.h),
              );
            }),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            Consumer<FinishedProvider>(
                builder: (context, finishedProvider, child) {
              return ListTile(
                onTap: () {
                  log("manga info:${widget.manga}");
                  if (widget.manga.isAddedToFinished == false) {
                    finishedProvider.addToFinishMangas(Manga(
                      title: widget.manga.title,
                      coverImageUrl: widget.manga.coverImageUrl,
                    ));
                  } else {
                    finishedProvider.removeFromeFinishMangas(widget.manga);
                  }
                  if (widget.manga.isAddedToFinished == true) {
                    widget.manga.isAddedToFinished = false;
                  } else {
                    widget.manga.isAddedToFinished = true;
                  }
                  log(widget.manga.isAddedToFinished.toString());
                },
                leading: !widget.manga.isAddedToFinished!
                    ? const Text("Add To 'I Already Read It'   😎")
                    : const Text("Remove Frome 'I Already Read It'   😎"),
                contentPadding: EdgeInsets.symmetric(vertical: 5.h),
              );
            }),
          ],
        ),
      ),
    );
  }
}
