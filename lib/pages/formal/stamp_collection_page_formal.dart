import 'package:flutter/material.dart';

import 'package:bookzone/model/Book.dart';
import 'package:bookzone/pages/abstract/stamp_collection_page_abstract.dart';
import 'package:bookzone/pages/formal/book_details_page_formal.dart';
import 'package:bookzone/utils/utils.dart';
import 'package:bookzone/widgets/stamp.dart';

class StampCollectionFormalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StampCollectionPageFormalState();
}

class _StampCollectionPageFormalState
    extends StampCollectionPageAbstractState<StampCollectionFormalPage> {
  @override
  Widget build(BuildContext context) {
    Widget body;

    if (items == []) {
      body = new Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty.png',
            height: 300.0,
            width: 300.0,
          ),
          Text(
            'Nothing is here',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ));
    } else {
      body = new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new Stamp(items[index].url, items[index].title);
        },
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
      );
    }

    body = new GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: items
          .map((Book book) => new Stamp(
                book.url,
                book.title,
                onClick: () {
                  Navigator.of(context).push(new FadeRoute(
                    builder: (BuildContext context) =>
                        new BookDetailsPageFormal(book),
                    settings: new RouteSettings(name: '/book_details_formal'),
                  ));
                },
              ))
          .toList(),
    );

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "Favorites",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headline6.color,
          ),
        ),
        elevation: 1.0,
      ),
      body: body,
    );
  }
}
