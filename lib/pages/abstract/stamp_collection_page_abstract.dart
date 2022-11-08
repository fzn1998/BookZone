import 'package:flutter/material.dart';
import 'package:bookzone/data/repository.dart';
import 'package:bookzone/model/Book.dart';
// ignore: unused_import
import 'package:bookzone/widgets/book_card_compact.dart';

abstract class StampCollectionPageAbstractState<T extends StatefulWidget>
    extends State<T> {
  List<Book> items = [];

  @override
  void initState() {
    super.initState();
    Repository.get().getFavoriteBooks().then((books) {
      setState(() {
        items = books;
      });
    });
  }
}
