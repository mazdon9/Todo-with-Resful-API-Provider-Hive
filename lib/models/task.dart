import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Task {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
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

  bool get isCompleted => status == 'completada';
  bool get isPending => status == 'pendiente';

  //convert form API json to Task object
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  //convert Task object to API json
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
