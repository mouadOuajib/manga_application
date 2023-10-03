import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<String> downloadedMangas = [];
  Map<String, List<String>> downloadedChapters = {};

  @override
  void initState() {
    super.initState();
    _loadDownloadedMangas();
  }

  Future<void> _loadDownloadedMangas() async {
    final directory = await getApplicationDocumentsDirectory();

    final mangaDirectories = await directory.list().where((entity) {
      return entity is Directory;
    }).toList();

    for (var mangaDirectory in mangaDirectories) {
      final mangaTitle = mangaDirectory.uri.pathSegments.last;
      downloadedMangas.add(mangaTitle);

      final chapterDirectories =
          await Directory(mangaDirectory.path).list().where((entity) {
        return entity is Directory;
      }).toList();

      final chapterTitles = chapterDirectories.map((chapterDirectory) {
        return chapterDirectory.uri.pathSegments.last;
      }).toList();

      downloadedChapters[mangaTitle] = chapterTitles;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: downloadedMangas.length,
        itemBuilder: (context, index) {
          final mangaTitle = downloadedMangas[index];
          final chapterTitles = downloadedChapters[mangaTitle] ?? [];
          return ListTile(
            title: Text(mangaTitle),
            subtitle: Text("Chapters: ${chapterTitles.join(", ")}"),
            onTap: () {},
          );
        },
      ),
    );
  }
}
