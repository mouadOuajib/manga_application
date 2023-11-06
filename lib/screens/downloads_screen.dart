import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
      final mangaPath = mangaDirectory.uri.path;
      final mangaTitle =
          path.basename(mangaPath); // Extract the manga title from the path
      downloadedMangas.add(mangaTitle);

      final chapterDirectories =
          await Directory(mangaPath).list().where((entity) {
        return entity is Directory;
      }).toList();

      final chapterTitles = chapterDirectories.map((chapterDirectory) {
        final chapterPath = chapterDirectory.uri.path;
        return path
            .basename(chapterPath); // Extract the chapter title from the path
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
