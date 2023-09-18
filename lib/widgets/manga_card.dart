import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MangaCard extends StatelessWidget {
  final String? title;
  final String? rating;
  final String? imageUrl;
  final String? lastChapter;
  final String? releasedDate;
  const MangaCard(
      {super.key,
      this.title,
      this.imageUrl,
      this.rating,
      this.lastChapter,
      this.releasedDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 120.w,
        decoration: BoxDecoration(
          color: theme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                              imageUrl!,
                            ),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    title!,
                    style: TextStyle(
                      color: theme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                "chapter: $lastChapter",
                style: TextStyle(color: theme.onBackground),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
