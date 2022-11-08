import 'dart:convert';

import 'package:bookzone/component/book_page.dart';
import 'package:bookzone/component/booklist.dart';
import 'package:bookzone/models/bookdetails.dart';
import 'package:bookzone/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:http/http.dart' as http;

Future<List<BookDetails>> fetchBooks(http.Client client, String genre) async {
  final response =
      await client.get('https://digiwebsite.github.io/bookzone/$genre.json');

  // Use the compute function to run parseBooks in a separate isolate.
  return compute(parseBooks, response.body);
}

// A function that converts a response body into a List<BookDetails>.
List<BookDetails> parseBooks(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<BookDetails>((json) => BookDetails.fromJson(json)).toList();
}

class Genre extends StatefulWidget {
  final String title;

  Genre({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  _GenreState createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.title}'),
      ),
      body: _buildBody('title'),
    );
  }

  Widget _buildBody(String genre) {
    return Container(
      child: _buildBodyList(genre),
    );
  }

  _buildBodyList(String genre) {
    return FutureBuilder<List<BookDetails>>(
        future: fetchBooks(http.Client(), genre),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          List<BookDetails> books = snapshot.data;

          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = books[index];

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      child: Booklistpdf(
                        book: item,
                        onClick: () {
                          Navigator.of(context).push(new FadeRoute(
                            builder: (BuildContext context) =>
                                new BookPageFormal(item),
                            settings: new RouteSettings(name: '/bookdetails'),
                          ));
                        },
                      ),
                    );
                  },
                )
              : Container(height: 200.0, child: LoadingWidget());
        });
  }
}
