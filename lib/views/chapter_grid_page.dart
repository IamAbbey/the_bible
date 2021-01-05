import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_bible/cubits/cubit/bible_cubit.dart';
import 'package:the_bible/models/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build_context/build_context.dart';
import 'package:the_bible/views/verse_list_view.dart';

class BookChapterGridView extends StatefulWidget {
  final Book book;
  BookChapterGridView({Key key, @required this.book}) : super(key: key);

  @override
  _BookChapterGridViewState createState() => _BookChapterGridViewState();
}

class _BookChapterGridViewState extends State<BookChapterGridView> {
  @override
  void initState() {
    context.read<BibleCubit>().fetchBookChapters(book: widget.book);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a chapter'),
      ),
      body: BlocBuilder<BibleCubit, BibleState>(
        buildWhen: (previous, current) =>
            current is ChapterFetchingLoading ||
            current is ChapterFetchingFailed ||
            current is ChapterFetchingSuccess,
        builder: (context, state) {
          if (state is ChapterFetchingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChapterFetchingSuccess) {
            return GridView.builder(
              itemCount: state.uniqueChapterNumbers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.isTablet ? 7 : 5,
              ),
              itemBuilder: (context, index) {
                final chapterNumber = state.uniqueChapterNumbers[index];
                final chapter = state.chapters
                    .where((obj) => obj.chapterNumber == chapterNumber)
                    .toList()
                    .first;
                return Container(
                  child: InkWell(
                    onTap: () => context.push(
                      CupertinoPageRoute(
                        builder: (context) => VerseListView(
                          book: widget.book,
                          chapter: chapter,
                        ),
                      ),
                    ),
                    child: Card(
                      child: Center(
                        child: Text(
                          '$chapterNumber',
                          style: context.textTheme.headline6,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is ChapterFetchingFailed) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }
}
