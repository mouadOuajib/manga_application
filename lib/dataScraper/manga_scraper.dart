import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:mangago/models/manga.dart';

class MangaScraper {
  final String baseUrl = "https://ww6.manganelo.tv/";

  //fetch search manga list
  Future<List<Manga>> fetchSearchList(String url) async {
    List<Manga> mangas = [];

    final response = await http.get(Uri.parse(url));
    log("url of search :$url");
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final mangaItems =
          document.querySelectorAll('.panel-search-story .search-story-item');

      for (var mangaItem in mangaItems) {
        final imgElement = mangaItem.querySelector('.item-img img');
        final imageUrl = imgElement?.attributes['src'];

        final titleElement = mangaItem.querySelector('.item-title');
        final title = titleElement?.text.trim() ?? '';

        final mangaUrl = titleElement?.attributes['href'] ?? '';

        final finalChapterElement = mangaItem.querySelector('.item-chapter');
        final finalChapter = finalChapterElement?.text.trim() ?? '';
        log(mangaUrl.toString());

        mangas.add(Manga(
          coverImageUrl: "https://ww6.manganelo.tv$imageUrl",
          title: title,
          mangaLink: "https://ww6.manganelo.tv$mangaUrl",
          lastChapter: finalChapter,
        ));
      }
    }

    return mangas;
  }

  //fetch latest manga
  Future<List<Manga>> latestManga(String url) async {
    List<Manga> mangas = [];

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final mangaItems = document.querySelectorAll('.content-genres-item');
      for (var mangaItem in mangaItems) {
        final imgElement = mangaItem.querySelector('.genres-item-img img');
        final imageUrl = imgElement?.attributes['src'] ?? '';

        final titleElement = mangaItem.querySelector('.genres-item-name');
        final title = titleElement?.text.trim() ?? '';

        final mangaUrl = titleElement?.attributes['href'] ?? '';

        final ratingElement = mangaItem.querySelector('.genres-item-rate');
        final rating = ratingElement?.text.trim() ?? '';

        final lastChapterElement = mangaItem.querySelector('.genres-item-chap');
        final lastChapter = lastChapterElement?.text.trim() ?? '';
        final lastChapterUrl = lastChapterElement?.attributes['href'] ?? '';
        log("mangaUrl$mangaUrl image=$imageUrl  title=$title");

        mangas.add(Manga(
          coverImageUrl: "https://ww6.manganelo.tv$imageUrl",
          title: title,
          mangaLink: "https://ww6.manganelo.tv$mangaUrl",
          rating: rating,
          lastChapter: lastChapter,
          lastChapterLink: lastChapterUrl,
        ));
      }
    }

    return mangas;
  }

  //fetch manga info
  Future<Manga> fetchMangaInfo(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);

      final tableValues =
          document.querySelectorAll('.variations-tableInfo .table-value');

      final alternative = tableValues[0].text.trim();
      final author = tableValues[1].querySelector('a.a-h')?.text.trim();
      final status = tableValues[2].text.trim();

      final genres = tableValues[3]
          .querySelectorAll('a.a-h')
          .map((element) => element.text.trim())
          .toList();

      final ratingElement = document.querySelector('em[property="v:average"]');
      final numberOfVotesElement =
          document.querySelector('em[property="v:votes"]');

      final rating = ratingElement != null
          ? double.tryParse(ratingElement.text.trim()) ?? 0.0
          : 0.0;
      final numberOfVotes = numberOfVotesElement != null
          ? int.tryParse(numberOfVotesElement.text.trim()) ?? 0
          : 0;
      final elements =
          document.querySelectorAll('.story-info-right-extent .stre-value');
      String views = "";
      String updated = "";
      if (elements.length >= 2) {
        updated = elements[0].text.trim();
        views = elements[1].text.trim();
      } else {
        log('Unable to retrieve date of update and views');
      }
      String description = document
              .querySelector('.panel-story-info-description')
              ?.text
              .trim() ??
          '';

      List<Map<String, String>> chapters = [];
      var chapterListItems =
          document.querySelectorAll('.row-content-chapter li');
      for (var chapterItem in chapterListItems) {
        String chapterName =
            chapterItem.querySelector('.chapter-name')?.text.trim() ?? '';
        String chapterLink =
            chapterItem.querySelector('.chapter-name')?.attributes['href'] ??
                '';
        String chapterTitle =
            chapterItem.querySelector('.chapter-name')?.attributes['title'] ??
                '';
        String views =
            chapterItem.querySelector('.chapter-view')?.text.trim() ?? '';
        String uploadDate =
            chapterItem.querySelector('.chapter-time')?.text.trim() ?? '';
        chapters.add({
          'title': chapterTitle,
          'chapterLink': "https://ww6.manganelo.tv$chapterLink",
          'chapterName': chapterName,
          'views': views,
          'uploadDate': uploadDate,
        });
      }
      log("alternative=$alternative author=$author status=$status genres=$genres  rating=$rating update=$updated view=$views numberofvotes=$numberOfVotes  story=$description chapters=$chapters ");
      return Manga(
        alternative: alternative,
        author: author,
        status: status,
        genres: genres,
        dateOfUpdate: updated,
        views: views,
        rating: rating.toString(),
        numberOfVotes: numberOfVotes,
        chaptersMap: chapters,
        story: description,
      );
    } else {
      throw Exception('Failed to fetch manga info');
    }
  }

  //fetch tags
  Future<List<String>> fetchTags() async {
    final response =
        await http.get(Uri.parse("https://ww6.manganelo.tv/genre?type=newest"));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final tags = <String>[];

      final categoryRows = document.querySelectorAll('.panel-genres-list');
      for (final row in categoryRows) {
        final tagElements = row.querySelectorAll('a');
        for (final element in tagElements) {
          final tag = element.text.trim();
          tags.add(tag);
        }
      }
      log(tags.toString());
      tags.remove("Pornographic");
      tags.remove("Yaoi");

      return tags;
    } else {
      throw Exception('Failed to fetch tags');
    }
  }

  //fetch chapter images
  static Future<List<String>> fetchImageUrls(String link) async {
    log(link);
    final images = <String>[];
    final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      // log(response.body.toString());
      final elements = document.querySelectorAll('.img-loading');
      for (final element in elements) {
        final imgSrc = element.attributes['data-src'];
        log(imgSrc.toString());
        if (imgSrc != null) {
          images.add(imgSrc);
        }
      }
    } else {
      log("status error: ${response.statusCode}");
    }
    log(images.toString());
    return images;
  }

  static Future<Manga> test(String link) async {
    log(link);
    Manga manga = Manga();
    final List<String> images = [];
    String? nextChapter = "";
    String? previousChapter = "";
    final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final elements = document.querySelectorAll('.img-loading');
      for (final element in elements) {
        final imgSrc = element.attributes['data-src'];
        log(imgSrc.toString());
        if (imgSrc != null) {
          images.add(imgSrc);
        }
      }
      final next = document.querySelector(".navi-change-chapter-btn-next");

      if (next != null) {
        nextChapter = next.attributes["href"];
      }
      final previous = document.querySelector(".navi-change-chapter-btn-prev");

      if (previous != null) {
        previousChapter = previous.attributes["href"];
      }
      log(nextChapter!);
      log(previousChapter!);
      manga = Manga(
          chapterImages: images,
          nextChapterUrl: nextChapter,
          previousChapterUrl: previousChapter);
    } else {
      log("status error: ${response.statusCode}");
    }
    return manga;
  }

  // static Future<List<String>> mangakakalot() async {
  //   final images = <String>[];
  //   final response = await http.get(Uri.parse(
  //       "https://ww6.mangakakalot.tv/chapter/manga-yp975598/chapter-44"));
  //   if (response.statusCode == 200) {
  //     final document = parser.parse(response.body);
  //     final elements = document.querySelectorAll('.img-loading');
  //     for (final element in elements) {
  //       final imgSrc = element.attributes['data-src'];
  //       log(imgSrc.toString());
  //       if (imgSrc != null) {
  //         images.add(imgSrc);
  //       }
  //     }
  //   } else {
  //     log("status error: ${response.statusCode}");
  //   }
  //   log(images.toString());
  //   return images;
  // }
}
