class Board {
  final int id;
  final String title;
  final String text;
  final int like;
  final int unlike;
  final List<String> imageUrls;

  const Board({
    required this.id,
    required this.title,
    required this.text,
    required this.like,
    required this.unlike,
    required this.imageUrls,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      like: json['text'],
      unlike: json['text'],
      imageUrls: List<String>.from(json['imageUrls']));
  }
}