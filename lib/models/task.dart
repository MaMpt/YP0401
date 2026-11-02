enum TaskStatus {
  todo,
  inProgress,
  review,
  done;

  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'К выполнению';
      case TaskStatus.inProgress:
        return 'В работе';
      case TaskStatus.review:
        return 'На проверке';
      case TaskStatus.done:
        return 'Завершено';
    }
  }
}

enum TaskPriority {
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Низкий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.high:
        return 'Высокий';
      case TaskPriority.critical:
        return 'Критический';
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String projectId;
  final String? assigneeId;
  final TaskStatus status;
  final TaskPriority priority;
  final List<String> tagIds;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.projectId,
    this.assigneeId,
    required this.status,
    required this.priority,
    this.tagIds = const [],
    required this.createdAt,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      projectId: json['projectId'] as String,
      assigneeId: json['assigneeId'] as String?,
      status: TaskStatus.values.byName(json['status'] as String),
      priority: TaskPriority.values.byName(json['priority'] as String),
      tagIds: (json['tagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'projectId': projectId,
      'assigneeId': assigneeId,
      'status': status.name,
      'priority': priority.name,
      'tagIds': tagIds,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? projectId,
    String? assigneeId,
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? tagIds,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      assigneeId: assigneeId ?? this.assigneeId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tagIds: tagIds ?? this.tagIds,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
