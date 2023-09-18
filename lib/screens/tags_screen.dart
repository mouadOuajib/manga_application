import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mangago/dataScraper/manga_scraper.dart';
import 'package:mangago/screens/manga_list.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  late Future<List<String>> getTages;
  final mangaScraper = MangaScraper();

  @override
  void initState() {
    getTages = mangaScraper.fetchTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " sorting options:",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const MangaList(
                                title: "Latest",
                                endPoint:
                                    "https://ww6.manganelo.tv/genre/Mature?page=",
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "\u2022Latest",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const MangaList(
                                title: "Newest",
                                endPoint:
                                    "https://ww6.manganelo.tv/genre/Mature?type=newest&page=",
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "\u2022Newest",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const MangaList(
                                title: "Top View",
                                endPoint:
                                    "https://ww6.manganelo.tv/genre/Mature?type=topview&page=",
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "\u2022Top View",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                " status of manga:",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const MangaList(
                                title: "All",
                                endPoint:
                                    "https://ww6.manganelo.tv/genre/Mature?page=",
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "\u2022All",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const MangaList(
                                title: "Completed",
                                endPoint:
                                    "https://ww6.manganelo.tv/genre/Mature?state=completed&page=",
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "\u2022Completed",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const MangaList(
                                title: "OnGoing",
                                endPoint:
                                    "https://ww6.manganelo.tv/genre/Mature?state=ongoing&page=",
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "\u2022OnGoing",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                " List of Tags:",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              FutureBuilder(
                future: getTages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return Text('Error: ${snapshot.error} gjsljdg');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    );
                  } else {
                    final mangas = snapshot.data!;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.maxFinite,
                      child: AnimationLimiter(
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          childAspectRatio: (80 / 30),
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          children: List.generate(
                            mangas.length,
                            (int index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                columnCount: 3,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: MangaList(
                                                    title: mangas[index],
                                                    endPoint:
                                                        "https://ww6.manganelo.tv/genre/${mangas[index]}?page=",
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "\u2022${mangas[index]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
