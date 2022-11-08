import 'package:bookzone/models/bookdetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:uuid/uuid.dart';

class Booklistpdf extends StatelessWidget {
  final BookDetails book;

  Booklistpdf({Key key, @required this.book, @required this.onClick})
      : super(key: key);

  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();
  final String descriptionTag = uuid.v4();
  final VoidCallback onClick;
  
  
  void checkdata() {
    if (book.source.metadata.author == null) {
      book.source.metadata.author = '';
    }
    if (book.source.metadata.description == null) {
      book.source.metadata.description = '';
    }
    if (book.source.metadata.subject == null) {
      book.source.metadata.subject = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    checkdata();
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 150.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: Hero(
                  tag: imgTag,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://cdn.bookmeth.com/' + book.source.coverurl,
                    placeholder: (context, url) => Container(
                      height: 150.0,
                      width: 100.0,
                      child: LoadingWidget(
                        isImage: true,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/place.png',
                      fit: BoxFit.scaleDown,
                      height: 150.0,
                      width: 100.0,
                    ),
                    fit: BoxFit.scaleDown,
                    height: 150.0,
                    width: 100.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: titleTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        '${book.source.title}',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Hero(
                    tag: authorTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        '${book.source.metadata.author}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Hero(
                    tag: descriptionTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        '${book.source.metadata.description}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).textTheme.headline2.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  String _short(String title, int targetLength) {
    var list = title.split(" ");
    int buffer = 0;
    String result = "";
    bool showedAll = true;
    for (String item in list) {
      if (buffer + item.length <= targetLength) {
        buffer += item.length;
        result += item += " ";
      } else {
        showedAll = false;
        break;
      }
    }
    //Handle case of one very long word
    if (result == "" && title.length > 18) {
      result = title.substring(0, 18);
      showedAll = false;
    }

    if (!showedAll) result += "...";
    return result;
  }
}
