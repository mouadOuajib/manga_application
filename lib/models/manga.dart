class Manga {
  String? title;
  String? description;
  String? coverImageUrl;
  String? chapterDateOfRelease;
  int? numberOfChapters;
  String? mangaLink;
  String? rating;
  String? lastChapter;
  String? lastChapterLink;
  bool? chapterIsNew;
  String? story;
  List<String>? genres;
  String? status;
  List<Map<String, String>>? chaptersMap;
  List<String>? chapterImages;
  String? nextChapterUrl;
  String? previousChapterUrl;
  String? alternative;
  String? author;
  String? dateOfUpdate;
  int? numberOfVotes;
  bool? isAddedToWatchLater;
  bool? isAddedToFavorite;
  bool? isAddedToCurrentRead;
  bool? isAddedToFinished;
  String? views;
  Manga(
      {this.title,
      this.coverImageUrl,
      this.chapterDateOfRelease,
      this.numberOfChapters,
      this.description,
      this.mangaLink,
      this.rating,
      this.lastChapter,
      this.lastChapterLink,
      this.genres,
      this.status,
      this.story,
      this.chaptersMap,
      this.chapterImages,
      this.chapterIsNew = false,
      this.isAddedToWatchLater = false,
      this.alternative,
      this.author,
      this.dateOfUpdate,
      this.numberOfVotes,
      this.views,
      this.nextChapterUrl,
      this.previousChapterUrl,
      this.isAddedToCurrentRead = false,
      this.isAddedToFavorite = false,
      this.isAddedToFinished = false});
}
