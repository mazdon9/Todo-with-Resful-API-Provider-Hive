class TodoModel {
  String title;
  String detail;
  bool isCompleted;

  TodoModel({
    required this.title,
    required this.detail,
    this.isCompleted = false,
  });
}
