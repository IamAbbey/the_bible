import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_bible/models/model.dart';
import 'package:meta/meta.dart';
import 'package:the_bible/services/utils.dart';
import 'package:build_context/build_context.dart';
import 'package:the_bible/views/chapter_grid_page.dart';

class SingleBookTile extends StatelessWidget {
  final Book book;
  const SingleBookTile({Key key, @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(
        CupertinoPageRoute(
          builder: (context) => BookChapterGridView(
            book: book,
          ),
        ),
      ),
      title: Text(book.longName),
      leading: Icon(
        Icons.circle,
        color: Color(
          Utils.getColorFromHex(book.bookColor),
        ),
      ),
      trailing: Icon(Icons.arrow_right),
    );
  }
}
