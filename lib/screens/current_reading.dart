import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangago/provider/current_reading_provider.dart';
import 'package:provider/provider.dart';

import 'manga_details.dart';

class CurrentReading extends StatefulWidget {
  const CurrentReading({super.key});

  @override
  State<CurrentReading> createState() => _CurrentReadingState();
}

class _CurrentReadingState extends State<CurrentReading> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: size.width,
        color: theme.primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Current Reading",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                const Divider(),
                SizedBox(
                  height: size.height * 0.5,
                  width: size.width,
                  child: Consumer<CurrentReadingProvider>(
                    builder: (context, currentProvider, child) {
                      final currentList = currentProvider.currentReadingList;
                      return ListView.builder(
                        itemCount: currentList.length,
                        itemBuilder: (context, index) {
                          final manga = currentList[index];
                          return SizedBox(
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MangaDetails(
                                                mangaLink: manga.mangaLink!,
                                                title: manga.title!,
                                                imageUrl:
                                                    manga.coverImageUrl!)));
                                  },
                                  title:
                                      Text(manga.title ?? "this is the title"),
                                  leading: Container(
                                    height: double.maxFinite,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              manga.coverImageUrl ??
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMwXlTVgzWwkn4gh0jlSAbp6DEzMIBPxREQub1kSs&s",
                                            ),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
