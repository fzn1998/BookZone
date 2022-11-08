import 'dart:async';
import 'dart:io';
import 'package:bookzone/models/bookdetails.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bookzone/model/Book.dart';

class BookDatabase {
  static final BookDatabase _bookDatabase = new BookDatabase._internal();

  final String tableName = "Books";

  Database db;

  bool didInit = false;

  static BookDatabase get() {
    return _bookDatabase;
  }

  BookDatabase._internal();

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return db;
  }

  Future init() async {
    return await _init();
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "bookzone.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute("CREATE TABLE $tableName ("
          "${Book.dbid} STRING PRIMARY KEY,"
          "${Book.dbtitle} TEXT,"
          "${Book.dburl} TEXT,"
          "${Book.dbstar} BIT,"
          "${Book.dbnotes} TEXT,"
          "${Book.dbauthor} TEXT,"
          "${Book.dbdescription} TEXT,"
          "${Book.dbsubtitle} TEXT,"
          "${Book.dbdownloadlink} TEXT,"
          "${Book.dbpages} INTEGER,"
          "${Book.dbsize} TEXT"
          ")");
    });
    didInit = true;
  }

  /// Get a book by its id, if there is not entry for that ID, returns null.
  Future<Book> getBook(String id) async {
    var db = await _getDb();
    var result = await db
        .rawQuery('SELECT * FROM $tableName WHERE ${Book.dbid} = "$id"');
    if (result.length == 0) return null;
    return new Book.fromMap(result[0]);
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<Book>> getBooks(List<String> ids) async {
    var db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${Book.dbid} IN ($idsString)');
    List<Book> books = [];
    for (Map<String, dynamic> item in result) {
      books.add(new Book.fromMap(item));
    }
    return books;
  }

  Future<List<Book>> getFavoriteBooks() async {
    var db = await _getDb();
    var result = await db
        .rawQuery('SELECT * FROM $tableName WHERE ${Book.dbstar} = "1"');
    if (result.length == 0) return [];
    List<Book> books = [];
    for (Map<String, dynamic> map in result) {
      books.add(new Book.fromMap(map));
    }
    return books;
  }

  // ignore: todo
  //TODO escape not allowed characters eg. ' " '
  /// Inserts or replaces the book.
  Future updateBook(Book book) async {
    var db = await _getDb();
    await db.rawInsert(
        'INSERT OR REPLACE INTO '
        '$tableName(${Book.dbid}, ${Book.dbtitle}, ${Book.dburl}, ${Book.dbstar}, ${Book.dbnotes}, ${Book.dbauthor}, ${Book.dbdescription}, ${Book.dbsubtitle},${Book.dbdownloadlink},${Book.dbpages},${Book.dbsize})'
        ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          book.id,
          book.title,
          book.url,
          book.starred ? 1 : 0,
          book.notes,
          book.author,
          book.description,
          book.subtitle,
          book.downloadlink,
          book.pages,
          book.size,
        ]);
  }

  Future updateBook2(BookDetails book) async {
    var db = await _getDb();
    await db.rawInsert(
        'INSERT OR REPLACE INTO '
        '$tableName(${Book.dbid}, ${Book.dbtitle}, ${Book.dburl}, ${Book.dbstar}, ${Book.dbnotes}, ${Book.dbauthor}, ${Book.dbdescription}, ${Book.dbsubtitle},${Book.dbdownloadlink},${Book.dbpages},${Book.dbsize})'
        ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          book.id,
          book.source.title,
          book.source.coverurl,
          book.source.starred ? 1 : 0,
          book.source.notes,
          book.source.metadata.author,
          book.source.metadata.description,
          book.source.metadata.subject,
          book.source.externallink,
          book.source.pages,
          '0'
        ]);
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }
}
