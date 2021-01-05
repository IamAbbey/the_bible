import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:build_context/build_context.dart';

class CustomAboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('About'),
      content: Wrap(
        children: [
          const Text('English Standard Version 2001, 2016\n'),
          Text(
            "The Holy Bible, English Standard Version. <br/>ESV® Permanent Text Edition® (2016). <br/>Copyright © 2001 by Crossway Bibles, a publishing ministry of Good News Publishers."
                .replaceAll('<br/>', '\n\n'),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'DISMISS',
            style: context.textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
