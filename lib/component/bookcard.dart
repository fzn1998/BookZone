import 'package:bookzone/models/bookdetails.dart';
import 'package:bookzone/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:uuid/uuid.dart';

import 'book_page.dart';

class BookCardpdf extends StatelessWidget {
  final String img;
  final BookDetails book;

  BookCardpdf({
    Key key,
    @required this.img,
    @required this.book,
  }) : super(key: key);

  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 4.0,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () {
            Navigator.of(context).push(new FadeRoute(
              builder: (BuildContext context) => new BookPageFormal(book),
              settings: new RouteSettings(name: '/bookdetails'),
            ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Hero(
              tag: imgTag,
              child: CachedNetworkImage(
                imageUrl: '$img',
                placeholder: (context, url) => LoadingWidget(
                  isImage: true,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/place.png',
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
