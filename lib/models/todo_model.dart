class TodoModel {
  String id;
  String title;
  String detail;
  bool isCompleted;

  TodoModel({
    this.id = '',
    required this.title,
    required this.detail,
    this.isCompleted = false,
  });

  // Convert from API JSON
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      detail: json['description'] ?? '',
      isCompleted: json['status'] == 'completed',
    );
  }

  // Convert to API JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': detail,
      'status': isCompleted ? 'completed' : 'pendiente',
    };
  }
}
