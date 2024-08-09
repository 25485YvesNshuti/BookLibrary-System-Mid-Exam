class Book {
  final int? id;
  final String title;
  final String author;
  final double rating;
  final bool isRead;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.rating,
    this.isRead = false,
  });

  Book copyWith({
    int? id,
    String? title,
    String? author,
    double? rating,
    bool? isRead,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'rating': rating,
        'isRead': isRead ? 1 : 0,
      };

  static Book fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] as int?,
        title: json['title'] as String,
        author: json['author'] as String,
        rating: json['rating'] as double,
        isRead: (json['isRead'] as int) == 1,
      );
}
