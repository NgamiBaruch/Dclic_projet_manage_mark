class Note {
  final int? id;
  final String title;
  final String content;
  final int createdAt; // epoch ms
  final int updatedAt; // epoch ms

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? createdAt,
    int? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        createdAt: map['createdAt'] as int,
        updatedAt: map['updatedAt'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
