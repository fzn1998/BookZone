import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bookzone/components/description_text.dart';
import 'package:bookzone/components/download_alert.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:bookzone/database/download_helper.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:meta/meta.dart';
import 'package:bookzone/data/repository.dart';
import 'package:bookzone/model/Book.dart';
import 'package:bookzone/pages/abstract/book_details_page_abstract.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'pdfviewer.dart';

class BookDetailsPageFormal extends StatefulWidget {
  BookDetailsPageFormal(this.book);

  final Book book;

  @override
  State<StatefulWidget> createState() => new _BookDetailsPageFormalState();
}

class _BookDetailsPageFormalState
    extends AbstractBookDetailsPageState<BookDetailsPageFormal> {
  GlobalKey<ScaffoldState> key = new GlobalKey();

  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();
  final String pagesTag = uuid.v4();
  final String subtitleTag = uuid.v4();
  final String sizeTag = uuid.v4();
  final dio = Dio();
  bool downloading = false;
  bool downloaded = false;
  bool faved = false;
  var progressString = "Downloading...";
  var dlDB = DownloadsDB();
  String desc = "Book Description";

  void checkdata() {
    if (widget.book.description == '') {
      desc = '';
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    checkFileExist();
    checkdata();
  }

  void getPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  void checkFileExist() async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/${widget.book.title}.pdf";
    if (File(fullPath).existsSync()) {
      setState(() {
        downloaded = true;
      });
    }
  }

  // ignore: unused_element
  /* Future _launchURL(String link) async {
    String url =
        'https://docs.google.com/viewerng/viewer?url=${Uri.encodeComponent(link)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

  Future _launchURL(BuildContext context, String link) async {
    String url =
        'https://docs.google.com/viewerng/viewer?url=${Uri.encodeComponent(link)}';
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          //animation: new CustomTabsAnimation.slideIn(),
          // or user defined animation.
          animation: new CustomTabsAnimation(
            startEnter: 'slide_up',
            startExit: 'android:anim/fade_out',
            endEnter: 'android:anim/fade_in',
            endExit: 'slide_down',
          ),
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

//Downloader
  Future download2(String url, String savePath) async {
    //get pdf from link

    //write in download folder
    File file = File(savePath);
    if (!await file.exists()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }

    setState(() {
      downloading = false;
      progressString = "";
      downloaded = true;
    });
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: savePath,
      ),
    ).then((v) {
      // When the download finishes, we then add the book
      // to our local database
      if (v != null) {
        addDownload(
          {
            'id': widget.book.id.toString(),
            'path': savePath,
            'image': 'https://cdn.bookmeth.com/' + widget.book.url,
            'size': v,
            'name': widget.book.title,
          },
        );
      }
    });
  }

  addDownload(Map body) async {
    await dlDB.add(body);
  }

  _buildSectionTitle(String desc) {
    return Text(
      desc,
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _buildDivider() {
    return Divider(
      color: Theme.of(context).textTheme.caption.color,
    );
  }

  _share() {
    Share.text(
      '${widget.book.title} by ${widget.book.author}',
      'Read/Download ${widget.book.title} from ${widget.book.downloadlink}.',
      'text/plain',
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => _share(),
            icon: Icon(
              Feather.share,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: imgTag,
                  child: CachedNetworkImage(
                    imageUrl: 'https://cdn.bookmeth.com/' + widget.book.url,
                    placeholder: (context, url) => Container(
                      height: 200.0,
                      width: 130.0,
                      child: LoadingWidget(),
                    ),
                    errorWidget: (context, url, error) => Icon(Feather.x),
                    fit: BoxFit.scaleDown,
                    height: 200.0,
                    width: 130.0,
                  ),
                ),
                SizedBox(width: 20.0),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Hero(
                        tag: titleTag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '${widget.book.title}',
                            style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Hero(
                        tag: authorTag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '${widget.book.author}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Hero(
                        tag: subtitleTag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '${widget.book.subtitle}',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(children: <Widget>[
                        Hero(
                          tag: pagesTag,
                          child: Material(
                            type: MaterialType.transparency,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                side: BorderSide(color: Colors.blue),
                              ),
                              onPressed: () {},
                              child: Text(
                                'pages: ${widget.book.pages}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Hero(
                          tag: sizeTag,
                          child: Material(
                            type: MaterialType.transparency,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                side: BorderSide(color: Colors.blue),
                              ),
                              onPressed: () {},
                              child: Text(
                                'size: ${widget.book.size} mb',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          _buildDivider(),
          SizedBox(height: 10.0),
          Row(children: <Widget>[
            new Expanded(
              child: new IconButtonText(
                onClick: () async {
                  String path =
                      await ExtStorage.getExternalStoragePublicDirectory(
                          ExtStorage.DIRECTORY_DOWNLOADS);
                  String fullPath = "$path/${widget.book.title}.pdf";
                  download2(widget.book.downloadlink, fullPath);
                },
                iconData: (Icons.download_sharp),
                text: downloaded ? "Redownload" : "Download",
                selected: false,
              ),
            ),
            downloaded
                ? new Expanded(
                    child: new IconButtonText(
                      onClick: () async {
                        try {
                          String path = await ExtStorage
                              .getExternalStoragePublicDirectory(
                                  ExtStorage.DIRECTORY_DOWNLOADS);
                          String fullPath = "$path/${widget.book.title}.pdf";
                          if (File(fullPath).existsSync()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewPage(path: fullPath)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Try Downloading first.',
                                style: TextStyle(fontSize: 17.0),
                              ),
                              duration: const Duration(seconds: 4),
                            ));
                          }
                        } catch (e) {}
                      },
                      iconData: Icons.read_more_sharp,
                      text: "Read Offline",
                      selected: false,
                    ),
                  )
                : Text(""),
            new Expanded(
              child: new IconButtonText(
                onClick: () {
                  _launchURL(context, widget.book.downloadlink);
                },
                iconData: Icons.read_more,
                text: "Read Online",
                selected: false,
              ),
            ),
            new Expanded(
              child: new IconButtonText(
                onClick: () {
                  setState(() {
                    widget.book.starred = !widget.book.starred;
                  });
                  Repository.get().updateBook(widget.book);
                },
                iconData: widget.book.starred ? Icons.favorite : Feather.heart,
                text: widget.book.starred ? "Remove" : "Add",
                selected: widget.book.starred,
              ),
            ),
          ]),
          SizedBox(height: 10.0),
          _buildDivider(),
          SizedBox(height: 30.0),
          _buildSectionTitle(desc),
          SizedBox(height: 12.0),
          DescriptionTextWidget(
            text: '${widget.book.description}',
          ),
          SizedBox(height: 20.0),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 10000),
              child: WebView(
                  gestureRecognizers: Set()
                    ..add(
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(),
                      ), // or null
                    ),
                  key: Key("webview1"),
                  debuggingEnabled: true,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl:
                      'https://docs.google.com/viewerng/viewer?url=${Uri.encodeComponent(widget.book.downloadlink)}')),
        ],
      ),
    );
  }
}

class IconButtonText extends StatelessWidget {
  IconButtonText(
      {@required this.onClick,
      @required this.iconData,
      @required this.text,
      this.selected = false});

  final VoidCallback onClick;

  final IconData iconData;
  final String text;
  final bool selected;

  final Color selectedColor = new Color(0xff283593);

  @override
  Widget build(BuildContext context) {
    return new InkResponse(
      onTap: onClick,
      child: new Column(
        children: <Widget>[
          new Icon(
            iconData,
          ),
          new Text(
            text,
          )
        ],
      ),
    );
  }
}
