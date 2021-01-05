import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_bible/cubits/cubit/bible_cubit.dart';
import 'package:the_bible/repositories/db_repo.dart';
import 'package:the_bible/services/constants.dart';
import 'package:the_bible/views/widgets/about_app_dialog.dart';
import 'package:the_bible/views/widgets/single_book_tile.dart';
import 'package:build_context/build_context.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BibleCubit>(
      create: (context) => BibleCubit(
        dbRepository: DBRepository(),
      ),
      child: MaterialApp(
        title: 'The Bible',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    context.read<BibleCubit>().fetchBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select a book'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'OLD TESTAMENT',
              ),
              Tab(
                text: 'NEW TESTAMENT',
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => CustomAboutDialog(),
              ),
            )
          ],
        ),
        body: BlocBuilder<BibleCubit, BibleState>(
          buildWhen: (previous, current) =>
              current is BookFetchingLoading ||
              current is BookFetchingFailed ||
              current is BookFetchingSuccess,
          builder: (context, state) {
            if (state is BookFetchingLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is BookFetchingSuccess) {
              return TabBarView(
                children: <Widget>[
                  ListView.builder(
                    itemCount: state.oldTestament.length,
                    itemBuilder: (context, index) {
                      final book = state.oldTestament[index];
                      return SingleBookTile(book: book);
                    },
                  ),
                  ListView.builder(
                    itemCount: state.newTestament.length,
                    itemBuilder: (context, index) {
                      final book = state.newTestament[index];
                      return SingleBookTile(book: book);
                    },
                  ),
                ],
              );
            } else if (state is BookFetchingFailed) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            return Container();
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
