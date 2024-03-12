class Task {
  final int? id;
  final String title;
  final String description;
  final bool isDeleted;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isDeleted = false,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDeleted': isDeleted ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDeleted: map['isDeleted'] == 1,
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }
}
