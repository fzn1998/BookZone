class MetaData {
  String author;
  String subject;
  String description;

  MetaData(
      {this.author = '',
      this.subject = '',
      this.description = 'No Description Available'});
  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      author: json['author'] as String,
      subject: json['subject'] as String,
      description: json['keywords'] as String,
    );
  }
}

class Source {
  final String title;
  String coverurl;
  final int pages;
  final String externallink;
  int size;
  final MetaData metadata;
  final notes;
  bool starred;

  Source(
      {this.title,
      this.coverurl = '',
      this.pages,
      this.externallink,
      this.size = 0,
      this.metadata,
      this.notes = '',
      this.starred = false});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
        title: json['title'] as String,
        coverurl: json['coverurl'] as String,
        pages: json['pages'] as int,
        externallink: json['external_link'] as String,
        size: json['size'] as int,
        metadata: MetaData.fromJson(json['metadata']),
        notes: '',
        starred: false);
  }
}

class BookDetails {
  final Source source;
  final String id;
  bool starred;
  BookDetails({this.source, this.id, this.starred = false});

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    return BookDetails(
        source: Source.fromJson(json['_source']),
        id: json['_id'] as String,
        starred: false);
  }
}
