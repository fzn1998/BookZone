import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:bookzone/model/Book.dart';
import 'package:bookzone/pages/formal/book_details_page_formal.dart';
import 'package:bookzone/utils/utils.dart';
import 'package:bookzone/widgets/stamp.dart';

class CollectionPreview extends StatefulWidget {
  final List<Book> books;

  final String title;

  CollectionPreview({
    @required this.title,
    this.books,
  });

  @override
  State<StatefulWidget> createState() => new _CollectionPreviewState();
}

class _CollectionPreviewState extends State<CollectionPreview> {
  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 32.0, fontFamily: 'CrimsonText', fontWeight: FontWeight.w400);
    return new ClipRect(
      child: new Align(
        heightFactor: 0.7,
        alignment: Alignment.topCenter,
        child: new ConstrainedBox(
          constraints: new BoxConstraints(
              minWidth: double.infinity,
              maxWidth: double.infinity,
              minHeight: 0.0,
              maxHeight: double.infinity),
          child: new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //       new Divider(color: Colors.black,),
                  new Text(
                    widget.title,
                    style: textStyle,
                  ),
                  new Stack(
                    children: <Widget>[
                      new SizedBox(
                        height: 350.0,
                        child: new ListView(
                            scrollDirection: Axis.horizontal,
                            children: widget.books
                                .map((book) => new Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: new Stamp(
                                        book.url,
                                        book.title,
                                        onClick: () {
                                          Navigator.of(context)
                                              .push(new FadeRoute(
                                            builder: (BuildContext context) =>
                                                new BookDetailsPageFormal(book),
                                            settings: new RouteSettings(
                                                name: '/book_detais_formal'),
                                          ));
                                        },
                                      ),
                                    ))
                                .toList()),
                      ),
                      new Container(),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
