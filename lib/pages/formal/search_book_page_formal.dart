import 'package:flutter/material.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:bookzone/pages/abstract/search_book_page_abstract.dart';
import 'package:bookzone/pages/formal/book_details_page_formal.dart';
import 'package:bookzone/utils/utils.dart';
import 'package:bookzone/widgets/book_card_compact.dart';

class SearchBookPageNew extends StatefulWidget {
  @override
  _SearchBookStateNew createState() => new _SearchBookStateNew();
}

class _SearchBookStateNew extends AbstractSearchBookState<SearchBookPageNew> {
  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 25.0, fontFamily: 'Butler', fontWeight: FontWeight.w700);
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search',
          style: textStyle,
        ),
      ),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: new SliverToBoxAdapter(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Card(
                      elevation: 4.0,
                      child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextField(
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          decoration: new InputDecoration(
                              hintText: "Which book do you want to read?",
                              hintStyle: TextStyle(
                                fontSize: 20.0,
                              ),
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.search,
                                ),
                              ),
                              border: InputBorder.none),
                          onSubmitted: (string) => (subject.add(string)),
                        ),
                      )),
                  new SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? new SliverToBoxAdapter(
                  child: new Center(child: LoadingWidget()),
                )
              : new SliverToBoxAdapter(),
          new SliverList(
              delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
            return new BookCardCompact(
              items[index],
              onClick: () {
                Navigator.of(context).push(new FadeRoute(
                  builder: (BuildContext context) =>
                      new BookDetailsPageFormal(items[index]),
                  settings: new RouteSettings(name: '/book_details_formal'),
                ));
              },
            );
          }, childCount: items.length))
        ],
      ),
    );
  }
}
