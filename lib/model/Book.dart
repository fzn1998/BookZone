import 'package:meta/meta.dart';

class Book {
  static final dbtitle = "title";
  static final dburl = "url";
  static final dbid = "id";
  static final dbnotes = "notes";
  static final dbstar = "star";
  static final dbauthor = "author";
  static final dbdescription = "description";
  static final dbsubtitle = "subtitle";
  static final dbdownloadlink = 'downloadlink';
  static final dbpages = 'pages';
  static final dbsize = 'size';
  String title, url, id, notes, description, subtitle, downloadlink, size;
  //First author
  int pages;
  String author;
  bool starred;
  Book({
    @required this.title,
    @required this.url,
    @required this.id,
    @required this.author,
    @required this.description,
    @required this.subtitle,
    @required this.downloadlink,
    @required this.pages,
    @required this.size,
    this.starred = false,
    this.notes = "",
  });

  Book.fromMap(Map<String, dynamic> map)
      : this(
          title: map[dbtitle],
          url: map[dburl],
          id: map[dbid],
          starred: map[dbstar] == 1,
          notes: map[dbnotes],
          description: map[dbdescription],
          author: map[dbauthor],
          subtitle: map[dbsubtitle],
          downloadlink: map[dbdownloadlink],
          pages: map[dbpages],
          size: map[dbsize],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      dbtitle: title,
      dburl: url,
      dbid: id,
      dbnotes: notes,
      dbstar: starred ? 1 : 0,
      dbdescription: description,
      dbauthor: author,
      dbsubtitle: subtitle,
      dbdownloadlink: downloadlink,
      dbpages: pages,
      dbsize: size,
    };
  }
}
