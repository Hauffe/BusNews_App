class BusNews {

  String title;
  String date;
  String content;
  String link;
  String imageURL;

  BusNews({this.title, this.date, this.content, this.link,
    this.imageURL});

  factory BusNews.fromJson(Map<String, dynamic> json) {
    return BusNews(
      title: json['title'],
      date: json['date'],
      content: json['content'],
      link: json['link'],
      imageURL: json['imageURL'],
    );
  }

}
