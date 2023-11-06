import 'dart:developer';
import 'dart:io';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangago/datascraper/manga_scraper.dart';
import 'package:mangago/screens/read_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/manga.dart';
import '../provider/watch_later.dart';
import 'package:provider/provider.dart';
import '../widgets/app_button.dart';
import '../widgets/upload_dialogue.dart';

class MangaDetails extends StatefulWidget {
  final String imageUrl;
  final String mangaLink;
  final String title;
  const MangaDetails(
      {Key? key,
      required this.mangaLink,
      required this.title,
      required this.imageUrl})
      : super(key: key);

  @override
  State<MangaDetails> createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> {
  MangaScraper mangaScraper = MangaScraper();
  late Future<Manga> getManga;
  bool ascendingOrder = true;

  void changeOrder(bool order) {
    setState(() {
      ascendingOrder = order;
    });
  }

  bool permissionGranted = false;

  @override
  void initState() {
    getManga = mangaScraper.fetchMangaInfo(widget.mangaLink);
    super.initState();
    _getStoragePermission();
  }

  Future _getStoragePermission() async {
    log("1");
    final permission = await Permission.storage.request().isGranted;
    log("get permission");
    log(permission.toString());
    if (permission) {
      setState(() {
        permissionGranted = true;
        log(permissionGranted.toString());
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else {
      log("the permission is denied");
    }
  }

  Future<void> downloadAndSaveChapters(String mangaTitle, String chapterTitle,
      List<String> chapterImages) async {
    final directory = await getApplicationDocumentsDirectory();
    final mangaDirectory =
        Directory('${directory.path}/$mangaTitle/$chapterTitle');
    await mangaDirectory.create(recursive: true);

    for (int i = 0; i < chapterImages.length; i++) {
      final request = await HttpClient().getUrl(Uri.parse(chapterImages[i]));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final Uint8List bytes =
            await consolidateHttpClientResponseBytes(response);

        final file = File('${mangaDirectory.path}/image_$i.jpg');
        await file.writeAsBytes(bytes);
      } else {
        log("images can't be downloded");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xfff9bbc3),
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: getManga,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Text('Error: ${snapshot.error} gjsljdg');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final manga = snapshot.data!;
                return Stack(
                  children: [
                    Container(
                      height: size.height / 2.5,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0xfff9bbc3),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 30.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 200,
                                width: 130,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(widget.imageUrl),
                                        fit: BoxFit.cover),
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 0.2,
                                        color: Colors.black,
                                        offset: Offset(0, 0),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.54,
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(manga.dateOfUpdate!),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Status: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                            text: '${manga.status} ',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Author: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                            text: '${manga.author} ',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Views: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                            text: '${manga.views} ',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Rating: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                            text: '${manga.rating} ',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: theme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height,
                            child: ContainedTabBarView(
                              tabs: const [
                                Text(
                                  'story',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'chapters',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'comments',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                              views: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 10, left: 10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Genres :",
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: Text(
                                            manga.genres!.join(' \u2022 '),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Alternative: ',
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text: '${manga.alternative} ',
                                                  style: const TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          "Description :",
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          manga.story!.substring(
                                              28, manga.story!.length),
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          "Options :",
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: [
                                            Consumer<WatchLaterProvider>(
                                              builder: (context,
                                                  watchLaterProvider, child) {
                                                return AppButton(
                                                  onTap: () {
                                                    log("manga info:$manga");
                                                    if (manga
                                                            .isAddedToWatchLater ==
                                                        false) {
                                                      // log(manga.title!);
                                                      // log(manga.coverImageUrl!);
                                                      watchLaterProvider
                                                          .addToWatchLater(
                                                              Manga(
                                                        mangaLink:
                                                            widget.mangaLink,
                                                        title: widget.title,
                                                        coverImageUrl:
                                                            widget.imageUrl,
                                                      ));
                                                    } else {
                                                      watchLaterProvider
                                                          .removeFromWatchLater(
                                                              manga);
                                                    }
                                                    if (manga
                                                            .isAddedToWatchLater ==
                                                        true) {
                                                      manga.isAddedToWatchLater =
                                                          false;
                                                    } else {
                                                      manga.isAddedToWatchLater =
                                                          true;
                                                    }
                                                    log(manga
                                                        .isAddedToWatchLater
                                                        .toString());
                                                  },
                                                  color: Colors.greenAccent,
                                                  buttontext: manga
                                                              .isAddedToWatchLater ==
                                                          false
                                                      ? "Read Later"
                                                      : "Remove Frome Read later",
                                                  width: 180.w,
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            AppButton(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return FadeTransition(
                                                        opacity: animation,
                                                        child: ReadPage(
                                                          chapterTitle:
                                                              "${manga.chaptersMap![manga.chaptersMap!.length - 1]['title']}",
                                                          mangaLink:
                                                              "${manga.chaptersMap![manga.chaptersMap!.length - 1]['chapterLink']}",
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              color: Colors.redAccent,
                                              buttontext: "Start Reading",
                                              width: 100.w,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        AppButton(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return UplaodDialog(
                                                  manga: Manga(
                                                      isAddedToFavorite: manga
                                                          .isAddedToFavorite,
                                                      isAddedToCurrentRead: manga
                                                          .isAddedToCurrentRead,
                                                      isAddedToFinished: manga
                                                          .isAddedToFinished,
                                                      isAddedToWatchLater: manga
                                                          .isAddedToWatchLater,
                                                      mangaLink:
                                                          widget.mangaLink,
                                                      title: widget.title,
                                                      coverImageUrl:
                                                          widget.imageUrl),
                                                );
                                              },
                                            );
                                          },
                                          buttontext: "...",
                                          color: theme.onBackground,
                                          width: 40.w,
                                          border: Border.all(
                                              color: Colors.grey, width: 0.3),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      child: Padding(
                                          padding: EdgeInsets.only(right: 20.w),
                                          child: InkWell(
                                            onTap: () {
                                              showOrderPopupMenu(context);
                                            },
                                            child: const Icon(
                                              Icons.more_horiz,
                                            ),
                                          )),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: manga.chaptersMap!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final chapter = ascendingOrder
                                              ? manga.chaptersMap![index]
                                              : manga.chaptersMap![
                                                  manga.chaptersMap!.length -
                                                      index -
                                                      1];
                                          if (chapter.isNotEmpty) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return FadeTransition(
                                                        opacity: animation,
                                                        child: ReadPage(
                                                          chapterTitle:
                                                              "${chapter['title']}",
                                                          mangaLink:
                                                              "${chapter['chapterLink']}",
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: ListTile(
                                                title: SizedBox(
                                                  width: double.maxFinite,
                                                  child: Text(
                                                    """${chapter["chapterName"]}""",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        """Views: ${chapter["views"]}"""),
                                                    Text(
                                                        """${chapter["uploadDate"]}"""),
                                                  ],
                                                ),
                                                trailing: InkWell(
                                                    onTap: () {
                                                      if (permissionGranted) {
                                                        downloadAndSaveChapters(
                                                            widget.title,
                                                            """${chapter["chapterName"]}""",
                                                            [
                                                              "https://cm.blazefast.co/1d/57/1d5799b2d06f4b91c5e245cd8b0aee0b.jpg",
                                                              "https://cm.blazefast.co/cf/4f/cf4fb340afc1ae8375ff7b5798dd1abb.jpg",
                                                              "https://cm.blazefast.co/ed/42/ed42d066ee78bceef49d6c4be47b02cc.jpg"
                                                            ]);
                                                      } else {
                                                        requestStoragePermission();
                                                      }
                                                    },
                                                    child: const Icon(
                                                        Icons.download)),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.green,
                                  child: const Center(
                                    child: Text(
                                      'Comments content goes here',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                              onChange: (index) => log(index.toString()),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showOrderPopupMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset(0.0, button.size.height));

    showMenu(
      context: context,
      position:
          RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: [
        const PopupMenuItem<bool>(
          value: true,
          child: Text('Newest First'),
        ),
        const PopupMenuItem<bool>(
          value: false,
          child: Text('Oldest First'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        changeOrder(value);
      }
    });
  }
}
