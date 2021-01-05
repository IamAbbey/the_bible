class Book {
  int bookNumber;
  String shortName;
  String longName;
  String bookColor;

  Book(this.bookNumber, this.shortName, this.longName, this.bookColor);

  Book.fromMap(Map<String, dynamic> map) {
    bookNumber = map['book_number'] as int;
    shortName = map['short_name'] as String;
    longName = map['long_name'] as String;
    bookColor = map['book_color'] as String;
  }
}

class Chapter {
  int bookNumber;
  int chapterNumber;
  int verse;
  String title;

  Chapter({this.bookNumber, this.chapterNumber, this.verse, this.title});

  Chapter.fromMap(Map<String, dynamic> map) {
    bookNumber = map['book_number'] as int;
    chapterNumber = map['chapter'] as int;
    verse = map['verse'] as int;
    title = map['title'] as String;
  }

  Chapter copyWith(Chapter chapter) => Chapter(
        bookNumber: chapter.bookNumber ?? bookNumber,
        chapterNumber: chapter.chapterNumber ?? chapterNumber,
        verse: chapter.verse ?? verse,
        title: chapter.title ?? title,
      );
}

class Verse {
  int bookNumber;
  int chapterNumber;
  int verse;
  String text;

  Verse(this.bookNumber, this.chapterNumber, this.verse, this.text);

  Verse.fromMap(Map<String, dynamic> map) {
    bookNumber = map['book_number'] as int;
    chapterNumber = map['chapter'] as int;
    verse = map['verse'] as int;
    text = map['text'] as String;
  }
}
