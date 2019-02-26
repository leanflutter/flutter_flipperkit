class Topic {
  final int id;
  String title;
  String content;
  String url;
  int created;

  Topic({
    this.id,
    this.title,
    this.content,
    this.url,
    this.created,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id      : json['id'],
      title   : json['title'],
      content : json['content'],
      url     : json['url'],
      created : json['created'],
    );
  }
}
