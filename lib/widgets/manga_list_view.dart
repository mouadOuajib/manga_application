import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mangago/widgets/manga_card.dart';
import '../dataScraper/manga_scraper.dart';
import '../models/manga.dart';

class AllMangaListView extends StatelessWidget {
  final String? endPoint;
  final VoidCallback? onTap;
  const AllMangaListView({super.key, this.endPoint, this.onTap});

  @override
  Widget build(BuildContext context) {
    final MangaScraper mangaScraper = MangaScraper();
    return SizedBox(
      height: 280.h,
      child: FutureBuilder(
        future: mangaScraper.fetchSearchList(endPoint ?? ""),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Text('Error: ${snapshot.error} gjsljdg');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Manga> latestMangas = snapshot.data as List<Manga>;

            return AnimationLimiter(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: latestMangas.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: () {},
                          child: MangaCard(
                            title: latestMangas[index].title,
                            imageUrl: latestMangas[index].coverImageUrl,
                            rating: latestMangas[index].rating,
                            lastChapter: latestMangas[index].lastChapter,
                            releasedDate:
                                latestMangas[index].chapterDateOfRelease,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
