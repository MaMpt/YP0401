class Comment {
  final String id;
  final String taskId;
  final String authorId;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.taskId,
    required this.authorId,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      authorId: json['authorId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'authorId': authorId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Comment copyWith({
    String? id,
    String? taskId,
    String? authorId,
    String? text,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
