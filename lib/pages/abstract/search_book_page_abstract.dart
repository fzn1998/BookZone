import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bookzone/data/repository.dart';
import 'package:bookzone/model/Book.dart';

abstract class AbstractSearchBookState<T extends StatefulWidget>
    extends State<T> {
  List<Book> items = [];

  final subject = new PublishSubject<String>();

  bool isLoading = false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  void _textChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      _clearList();
      return;
    }
    setState(() {
      isLoading = true;
    });
    _clearList();
    Repository.get().getBooks(text).then((books) {
      setState(() {
        isLoading = false;
        if (books.isOk()) {
          items = books.body;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: new Text(
                  "Something went wrong, check your internet connection")));
        }
      });
    });
  }

  void _clearList() {
    setState(() {
      items.clear();
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subject.stream
        .debounce(new Duration(milliseconds: 600))
        .listen(_textChanged);
  }
}
