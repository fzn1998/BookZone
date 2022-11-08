import 'dart:convert';

import 'package:bookzone/component/bookcard.dart';
import 'package:bookzone/models/bookdetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:bookzone/util/router.dart';
import 'package:bookzone/views/genre/genre.dart';

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

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 25.0, fontFamily: 'Butler', fontWeight: FontWeight.w700);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Explore',
          style: textStyle,
        ),
      ),
      body: Container(
        child: _buildBodyList(),
      ),
    );
  }

  _buildBodyList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ListView(
        children: <Widget>[
          _buildSectionHeader('Adventure'),
          SizedBox(height: 10.0),
          _buildSectionBookList('adventure'),
          SizedBox(height: 10.0),
          _buildSectionHeader('Horror'),
          SizedBox(height: 10.0),
          _buildSectionBookList('horror'),
          SizedBox(height: 10.0),
          _buildSectionHeader('Romance'),
          SizedBox(height: 10.0),
          _buildSectionBookList('romance'),
          SizedBox(height: 10.0),
          _buildSectionHeader('Story'),
          SizedBox(height: 10.0),
          _buildSectionBookList('story'),
          SizedBox(height: 10.0),
          _buildSectionHeader('Mystery'),
          SizedBox(height: 10.0),
          _buildSectionBookList('mystery'),
          SizedBox(height: 10.0),
          _buildSectionHeader('Fanstasy'),
          SizedBox(height: 10.0),
          _buildSectionBookList('fantasy'),
          SizedBox(height: 10.0),
          _buildSectionHeader('Literary'),
          SizedBox(height: 10.0),
          _buildSectionBookList('literary'),
          SizedBox(height: 10.0),
          _buildSectionHeader('Drama'),
          SizedBox(height: 10.0),
          _buildSectionBookList('drama'),
        ],
      ),
    );
  }

  _buildSectionHeader(String genre) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              '$genre',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              MyRouter.pushPage(
                context,
                Genre(
                  title: '$genre',
                ),
              );
            },
            child: Text(
              'See All',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSectionBookList(String genre) {
    return FutureBuilder<List<BookDetails>>(
        future: fetchBooks(http.Client(), genre),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          List<BookDetails> books = snapshot.data;
          return snapshot.hasData
              ? Container(
                  height: 200.0,
                  child: Center(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final item = books[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 10.0,
                          ),
                          child: BookCardpdf(
                            img: 'https://cdn.bookmeth.com/' +
                                item.source.coverurl,
                            book: item,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container(height: 200.0, child: LoadingWidget());
        });
  }
}
