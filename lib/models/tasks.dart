import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasks.g.dart';

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
  @HiveField(4)
  final bool onlyOnline;
  @HiveField(5)
  final bool needsSync;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.onlyOnline = false,
    this.needsSync = false,
  });
  bool get isCompleted => status == 'completada';
  bool get isPending => status == 'pendiente';
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    bool? OnlyOnline,
    bool? needsSync,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      onlyOnline: OnlyOnline ?? this.onlyOnline,
      needsSync: needsSync ?? this.needsSync,
    );
  }

  // Convert from API JSON
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  // Convert to API JSON
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
