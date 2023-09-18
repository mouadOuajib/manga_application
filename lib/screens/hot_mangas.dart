import 'package:flutter/material.dart';
import 'package:mangago/screens/already_read_it.dart';
import 'package:mangago/screens/current_reading.dart';
import 'package:mangago/screens/favorite_mangas.dart';
import 'package:mangago/screens/read_later.dart';

class FavoriteMangaPage extends StatelessWidget {
  final List<String> listText = [
    "Read later",
    "Favorite",
    "I already read it",
    "Current reading"
  ];

  final List screens = const [
    ReadLater(),
    FavoriteManga(),
    FinishedManga(),
    CurrentReading(),
  ];

  FavoriteMangaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: listText.length,
        itemBuilder: (context, index) {
          return SizedBox(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    listText[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => screens[index]));
                  },
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
