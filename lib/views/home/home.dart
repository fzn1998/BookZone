import 'dart:convert';
import 'dart:ui';

import 'package:bookzone/component/book_page.dart';
import 'package:bookzone/component/bookcard.dart';
import 'package:bookzone/component/booklist.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:bookzone/models/bookdetails.dart';
import 'package:bookzone/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';
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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  ScrollController _controller = new ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Row(
            children: <Widget>[
              Text(
                "Bo",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              Column(
                children: <Widget>[
                  Text(
                    "o",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  Container(
                    height: 6,
                    width: 15,
                  )
                ],
              ),
              Text(
                "kZo",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              Text(
                "ne",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              )
            ],
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search_formal');
            },
          ),
        ],
        leading: IconButton(
          icon: new Icon(Feather.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: _buildBodyList(),
    );
  }

  Widget _buildBodyList() {
    return RefreshIndicator(
      onRefresh: () => fetchBooks(http.Client(), 'horror'),
      child: ListView(
        children: <Widget>[
          _buildFeaturedSection('horror'),
          SizedBox(height: 10.0),
          _buildSectionTitle('New Arrival'),
          SizedBox(height: 10.0),
          buildBodyList('romance'),
        ],
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _buildFeaturedSection(String genre) {
    return FutureBuilder<List<BookDetails>>(
      future: fetchBooks(http.Client(), genre),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        List<BookDetails> books = snapshot.data;
        return snapshot.hasData
            ? Container(
                height: 320.0,
                child: Center(
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 0.44,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item = books[index];
                      return Container(
                        child: Container(
                          margin: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 250,
                                width: 170,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: BookCardpdf(
                                  img: 'https://cdn.bookmeth.com/' +
                                      item.source.coverurl,
                                  book: item,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: books.length,
                  ),
                ),
              )
            : Container(height: 200.0, child: LoadingWidget());
      },
    );
  }

  buildBodyList(String genre) {
    return FutureBuilder<List<BookDetails>>(
        future: fetchBooks(http.Client(), genre),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          List<BookDetails> books = snapshot.data;

          if (snapshot.hasData) {
            return ListView.builder(
              controller: _controller,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              shrinkWrap: true,
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                final item = books[index];
                if (item.source.externallink.contains('.') == true) {
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
                } else {
                  return null;
                }
              },
            );
          } else {
            return Container(height: 200.0, child: LoadingWidget());
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
