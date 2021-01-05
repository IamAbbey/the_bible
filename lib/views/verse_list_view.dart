import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:the_bible/cubits/cubit/bible_cubit.dart';
import 'package:the_bible/models/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build_context/build_context.dart';
import 'package:the_bible/services/utils.dart';
import 'package:flutter/services.dart';

class VerseListView extends StatefulWidget {
  final Book book;
  final Chapter chapter;
  VerseListView({Key key, @required this.book, @required this.chapter})
      : super(key: key);

  @override
  _VerseListViewState createState() => _VerseListViewState();
}

class _VerseListViewState extends State<VerseListView> {
  @override
  void initState() {
    context.read<BibleCubit>().fetchChapterVerse(
          book: widget.book,
          chapter: widget.chapter,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentBook = context.watch<BibleCubit>().currentBook;
    final currentChapter = context.watch<BibleCubit>().currentChapter;

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentBook.longName} ${currentChapter.chapterNumber}'),
      ),
      body: BlocBuilder<BibleCubit, BibleState>(
        buildWhen: (previous, current) =>
            current is VerseFetchingLoading ||
            current is VerseFetchingFailed ||
            current is VerseFetchingSuccess,
        builder: (context, state) {
          if (state is VerseFetchingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VerseFetchingSuccess) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  final chapter = currentChapter;
                  if (details.globalPosition.dx > 0) {
                    context.read<BibleCubit>().fetchChapterVerse(
                          chapter: chapter.copyWith(
                            Chapter(
                              chapterNumber: chapter.chapterNumber + 1,
                            ),
                          ),
                          book: widget.book,
                        );
                  } else if (details.globalPosition.dx < 0) {
                    context.read<BibleCubit>().fetchChapterVerse(
                          chapter: chapter.copyWith(
                            Chapter(
                              chapterNumber: chapter.chapterNumber - 1,
                            ),
                          ),
                          book: widget.book,
                        );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentChapter.title,
                        style: context.textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.verses.length,
                        itemBuilder: (context, index) {
                          final verse = state.verses[index];
                          final formattedVerse =
                              Utils.formatVerseText(verse.text);
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: InkWell(
                              onTap: () {
                                Clipboard.setData(
                                        ClipboardData(text: formattedVerse))
                                    .then((_) {
                                  Scaffold.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Bible verse copied to clipboard"),
                                    ),
                                  );
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '\t\t${verse.verse}\t\t',
                                    style: context.textTheme.bodyText2,
                                  ),
                                  Expanded(
                                    child: Html(
                                      shrinkWrap: true,
                                      data: formattedVerse,
                                      style: {
                                        'mark': Style(
                                          color: Colors.red,
                                        ),
                                        'div': Style(
                                          color:
                                              context.textTheme.bodyText2.color,
                                        ),
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is VerseFetchingFailed) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }
}
