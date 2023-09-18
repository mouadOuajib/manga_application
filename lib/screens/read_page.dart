import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangago/dataScraper/manga_scraper.dart';
import 'package:mangago/models/manga.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/services.dart';

class ReadPage extends StatefulWidget {
  final String chapterTitle;
  final String mangaLink;
  const ReadPage(
      {Key? key, required this.chapterTitle, required this.mangaLink})
      : super(key: key);

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  late Future<Manga> getManga;
  bool _isAppBarVisible = false;
  bool _isHorizontalMode = true;
  late String nextChapter;
  late String previousChapter;
  bool loading = false;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    getManga = MangaScraper.test(widget.mangaLink);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleAppBarVisibility() {
    setState(() {
      _isAppBarVisible = !_isAppBarVisible;
    });
  }

  void _toggleReadingMode() {
    setState(() {
      _isHorizontalMode = !_isHorizontalMode;
    });
  }

  Widget _buildAppBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _isAppBarVisible ? 90.h : 0,
      child: AppBar(
        title: Text(
          widget.chapterTitle,
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          InkWell(
            onTap: _toggleReadingMode,
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.5),
                    shape: BoxShape.circle,
                    color: Colors.transparent),
                height: 30,
                width: 30,
                child: _isHorizontalMode
                    ? const Center(child: Icon(Icons.horizontal_distribute))
                    : const Center(child: Icon(Icons.vertical_align_bottom)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMangaPage(int pageIndex, List images) {
    final imageUrl = images[pageIndex];

    if (_isHorizontalMode) {
      return Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 2,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    } else {
      return InteractiveViewer(
        minScale: 1.0,
        maxScale: 2,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // double _calculateMaxScale(String imageUrl) {
  //   final double imageWidth = MediaQuery.of(context).size.width;
  //   final double deviceWidth = MediaQuery.of(context).size.width;
  //   final double maxScale = deviceWidth / imageWidth;
  //   return maxScale;
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: GestureDetector(
        onTap: _toggleAppBarVisibility,
        child: Stack(
          children: [
            FutureBuilder(
              future: getManga,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Text('Error: ${snapshot.error} gjsljdg');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final manga = snapshot.data as Manga;
                  return _isHorizontalMode
                      ? PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: manga.chapterImages!.length,
                          itemBuilder: (context, index) {
                            nextChapter = manga.nextChapterUrl ?? "";
                            previousChapter = manga.previousChapterUrl ?? "";
                            log(nextChapter + previousChapter);
                            return _buildMangaPage(index, manga.chapterImages!);
                          },
                        )
                      : ScrollablePositionedList.builder(
                          itemScrollController: _itemScrollController,
                          scrollDirection: Axis.vertical,
                          itemCount: manga.chapterImages!.length,
                          itemBuilder: (context, index) {
                            log(manga.toString());
                            nextChapter = manga.nextChapterUrl ?? "";
                            previousChapter = manga.previousChapterUrl ?? "";
                            log(nextChapter + previousChapter);
                            return _buildMangaPage(index, manga.chapterImages!);
                          },
                        );
                }
              },
            ),
            if (_isAppBarVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60.h,
                  color: theme.primary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (previousChapter != "")
                          InkWell(
                              onTap: () {
                                if (previousChapter.isNotEmpty) {
                                  log(widget.mangaLink);
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ReadPage(
                                            chapterTitle: "",
                                            mangaLink:
                                                "https://ww6.manganelo.tv$previousChapter",
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              child: const Icon(Icons.arrow_back)),
                        if (nextChapter != "")
                          InkWell(
                              onTap: () {
                                if (nextChapter.isNotEmpty) {
                                  log(widget.mangaLink);
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ReadPage(
                                            chapterTitle: "",
                                            mangaLink:
                                                "https://ww6.manganelo.tv$nextChapter",
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              child: const Icon(Icons.arrow_forward)),
                      ],
                    ),
                  ),
                ),
              ),
            _buildAppBar(),
          ],
        ),
      ),
    );
  }
}
