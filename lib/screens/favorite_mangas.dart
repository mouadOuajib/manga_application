import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangago/provider/favorite_provider.dart';
import 'package:mangago/screens/manga_details.dart';
import 'package:provider/provider.dart';

class FavoriteManga extends StatefulWidget {
  const FavoriteManga({super.key});

  @override
  State<FavoriteManga> createState() => _FavoriteMangaState();
}

class _FavoriteMangaState extends State<FavoriteManga> {
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
                  "Favorite Mangas",
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
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      final favoriteList = favoriteProvider.favoriteList;
                      return ListView.builder(
                        itemCount: favoriteList.length,
                        itemBuilder: (context, index) {
                          final manga = favoriteList[index];
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
