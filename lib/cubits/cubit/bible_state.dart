part of 'bible_cubit.dart';

abstract class BibleState extends Equatable {
  const BibleState();

  @override
  List<Object> get props => [];
}

class BibleInitial extends BibleState {}

class BookFetchingLoading extends BibleState {}

class BookFetchingSuccess extends BibleState {
  final List<Book> books;
  final List<Book> oldTestament;
  final List<Book> newTestament;

  BookFetchingSuccess({
    @required this.books,
    @required this.oldTestament,
    @required this.newTestament,
  });

  @override
  List<Object> get props => [books];
}

class BookFetchingFailed extends BibleState {
  final String errorMessage;

  BookFetchingFailed({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ChapterFetchingLoading extends BibleState {}

class ChapterFetchingSuccess extends BibleState {
  final List<Chapter> chapters;
  final List<int> uniqueChapterNumbers;

  ChapterFetchingSuccess({
    @required this.chapters,
    @required this.uniqueChapterNumbers,
  });

  @override
  List<Object> get props => [chapters, uniqueChapterNumbers];
}

class ChapterFetchingFailed extends BibleState {
  final String errorMessage;

  ChapterFetchingFailed({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class VerseFetchingLoading extends BibleState {}

class VerseFetchingSuccess extends BibleState {
  final List<Verse> verses;

  VerseFetchingSuccess({
    @required this.verses,
  });

  @override
  List<Object> get props => [verses,];
}

class VerseFetchingFailed extends BibleState {
  final String errorMessage;

  VerseFetchingFailed({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}