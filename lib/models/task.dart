class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
