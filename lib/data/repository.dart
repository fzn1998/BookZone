import 'dart:async';
import 'dart:convert';

// ignore: unused_import
import 'package:bookzone/models/bookdetails.dart';
import 'package:bookzone/data/database.dart';
import 'package:bookzone/model/Book.dart';
import 'package:http/http.dart' as http;

/// A class similar to http.Response but instead of a String describing the body
/// it already contains the parsed Dart-Object
class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);
  final int statusCode;
  final T body;

  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}

final int noInternet = 404;

class Repository {
  static final Repository _repo = new Repository._internal();

  BookDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = BookDatabase.get();
  }

  Future init() async {
    return await database.init();
  }

  /// Fetches the books from the BookMeth Api with the query parameter being input.
  /// If a book also exists in the local storage (eg. a book with notes/ stars) that version of the book will be used instead
  Future<ParsedResponse<List<Book>>> getBooks(String input) async {
    //http request, catching error like no internet connection.
    //If no internet is available for example response is
    var value = {'q': input};
    var uri = Uri.parse("https://bookmeth1.p.rapidapi.com/")
        .replace(queryParameters: value)
        .toString();

    http.Response response = await http.get(uri, headers: {
      'x-rapidapi-host': "bookmeth1.p.rapidapi.com",
      'x-rapidapi-key': "e936507c45msh9da6ff7d46a1ab2p1ab7e0jsn90c10afc25e0"
    });
    if (response == null) {
      return new ParsedResponse(noInternet, []);
    }

    //If there was an error return an empty list
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return new ParsedResponse(response.statusCode, []);
    }
    // Decode and go to the items part where the necessary book information is
    List<dynamic> list = jsonDecode(response.body);

    Map<String, Book> networkBooks = {};

    for (dynamic jsonBook in list) {
      Book book = parseNetworkBook(jsonBook);
      networkBooks[book.id] = book;
    }

    //Adds information (if available) from database
    List<Book> databaseBook =
        await database.getBooks([]..addAll(networkBooks.keys));
    for (Book book in databaseBook) {
      networkBooks[book.id] = book;
    }

    return new ParsedResponse(
        response.statusCode, []..addAll(networkBooks.values));
  }

/*
  Future<ParsedResponse<Book>> getBook(String id) async {
    http.Response response = await http
        .get("https://www.googleapis.com/books/v1/volumes/$id")
        .catchError((resp) {});
    if (response == null) {
      return new ParsedResponse(noInternet, null);
    }

    //If there was an error return null
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return new ParsedResponse(response.statusCode, null);
    }

    dynamic jsonBook = jsonDecode(response.body);

    Book book = parseNetworkBook(jsonBook);

    //Adds information (if available) from database
    List<Book> databaseBook = await database.getBooks([]..add(book.id));
    for (Book databaseBook in databaseBook) {
      if (databaseBook != null) {
        book = databaseBook;
      }
    }

    return new ParsedResponse(response.statusCode, book);
  }

  Future<List<Book>> getBooksById(List<String> ids) async {
    List<Book> books = [];

    //  int statusCode = 200;
    for (String id in ids) {
      ParsedResponse<Book> book = await getBook(id);

      // One of the books went wrong, save status code and continue
      //   if(book.statusCode < 200 || book.statusCode >= 300) {
      //     statusCode = book.statusCode;
      //    }

      if (book.body != null) {
        books.add(book.body);
      }
    }

    return books;
    //  return new ParsedResponse(statusCode, books);
  }
*/
  Future<List<Book>> getBooksByIdFirstFromDatabaseAndCache(
      List<String> ids) async {
    List<Book> books = [];
    List<String> idsToFetch = ids;

    List<Book> databaseBook = await database.getBooks([]..addAll(ids));

    for (Book databaseBook in databaseBook) {
      books.add(databaseBook);
      idsToFetch.remove(databaseBook.id);
    }

    /* for (String id in idsToFetch) {
      http.Response response = await http
          .get("https://www.googleapis.com/books/v1/volumes/$id")
          .catchError((resp) {});
      /*  if(response == null) {
        return new ParsedResponse(NO_INTERNET, null);
      }

      //If there was an error return null
      if(response.statusCode < 200 || response.statusCode >= 300) {
        return new ParsedResponse(response.statusCode, null);
      }*/

      dynamic jsonBook = jsonDecode(response.body);

      Book book = parseNetworkBook(jsonBook);
      updateBook(book);
      books.add(book);
    }
  */
    return books;
  }

  Book parseNetworkBook(jsonBook) {
    Map metadata = jsonBook["_source"]["metadata"];

    String author = " ";
    if (metadata.containsKey("author")) {
      author = metadata["author"];
    }
    String description = " ";
    if (metadata.containsKey("keywords")) {
      description = metadata["keywords"];
    }
    String subtitle = " ";
    if (metadata.containsKey("subject")) {
      subtitle = metadata["subject"];
    }
    int sizeinBytes = jsonBook["_source"]["size"];
    double sizeinMb = (sizeinBytes / (1024 * 1024));
    return new Book(
      title: jsonBook["_source"]["title"],
      url: jsonBook["_source"]["coverurl"],
      id: jsonBook["_id"],
      downloadlink: jsonBook["_source"]["external_link"],
      pages: jsonBook["_source"]["pages"],
      author: author,
      description: description,
      subtitle: subtitle,
      size: sizeinMb.toStringAsFixed(2),
    );
  }

  Future updateBook(Book book) async {
    await database.updateBook(book);
  }

  Future updateBook2(BookDetails book) async {
    await database.updateBook2(book);
  }

  Future close() async {
    return database.close();
  }

  Future<List<Book>> getFavoriteBooks() {
    return database.getFavoriteBooks();
  }
}
