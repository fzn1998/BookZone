import 'package:flutter/material.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:bookzone/theme/theme_config.dart';
import 'package:bookzone/view_models/app_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Row(
            children: <Widget>[
              Text(
                "      Bo",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              Column(
                children: <Widget>[
                  Text(
                    "o",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  Container(
                    height: 3,
                    width: 15,
                  )
                ],
              ),
              Text(
                "kZone Viewer",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: Provider.of<AppProvider>(context).theme ==
                    ThemeConfig.lightTheme
                ? false
                : true,
            onError: (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Unable to open',
                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                ),
                duration: const Duration(seconds: 4),
              ));
            },
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
                  child: LoadingWidget(),
                )
              : Offstage(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _currentPage > 0
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.black54,
                  label: Text("Go to ${_currentPage - 1}",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _currentPage -= 1;
                    _pdfViewController.setPage(_currentPage);
                  },
                )
              : Offstage(),
          _currentPage + 1 < _totalPages
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.black87,
                  label: Text(
                    "Go to ${_currentPage + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _currentPage += 1;
                    _pdfViewController.setPage(_currentPage);
                  },
                )
              : Offstage(),
        ],
      ),
    );
  }
}
