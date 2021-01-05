import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_bible/models/model.dart';
import 'package:the_bible/repositories/db_repo.dart';
import 'package:meta/meta.dart';
import 'package:the_bible/services/constants.dart';

part 'bible_state.dart';

class BibleCubit extends Cubit<BibleState> {
  final DBRepository dbRepository;
  Book currentBook;
  Chapter currentChapter;
  List<Chapter> currentChapertList;
  Verse currentVerse;

  BibleCubit({@required this.dbRepository}) : super(BibleInitial());

  Future<void> fetchBooks() async {
    emit(BookFetchingLoading());
    await dbRepository.initializeDB(k_ESV_DB);
    try {
      final response = await dbRepository.fetchBooks();
      emit(
        BookFetchingSuccess(
          books: response,
          oldTestament: response.sublist(0, 39),
          newTestament: response.sublist(39),
        ),
      );
    } catch (e) {
      emit(BookFetchingFailed(errorMessage: e.toString()));
    }
  }

  Future<void> fetchBookChapters({@required Book book}) async {
    emit(ChapterFetchingLoading());
    try {
      final response =
          await dbRepository.fetchBookChapters(bookNumber: book.bookNumber);
      final uniqueChapterNumbers =
          response.map((chapter) => chapter.chapterNumber).toSet().toList();
      currentBook = book;
      currentChapertList = response;
      emit(ChapterFetchingSuccess(
        chapters: response,
        uniqueChapterNumbers: uniqueChapterNumbers,
      ));
    } catch (e) {
      emit(ChapterFetchingFailed(errorMessage: e.toString()));
    }
  }

  Future<void> fetchChapterVerse({
    @required Chapter chapter,
    @required Book book,
  }) async {
    emit(VerseFetchingLoading());
    try {
      final response = await dbRepository.fetchBookVerses(
        chapterNumber: chapter.chapterNumber,
        bookNumber: book.bookNumber,
      );
      currentBook = book;
      currentChapter = currentChapertList
                    .where((obj) => obj.chapterNumber == chapter.chapterNumber)
                    .toList()
                    .first;
      emit(
        VerseFetchingSuccess(
          verses: response,
        ),
      );
    } catch (e) {
      emit(VerseFetchingFailed(errorMessage: e.toString()));
    }
  }
}
