import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Task {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final bool isLocalOnly;

  @HiveField(5)
  final bool needsSync;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    this.isLocalOnly = false,
    this.needsSync = false,
  });

  bool get isCompleted => status == 'completada';
  bool get isPending => status == 'pendiente';

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    bool? isLocalOnly,
    bool? needsSync,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      isLocalOnly: isLocalOnly ?? this.isLocalOnly,
      needsSync: needsSync ?? this.needsSync,
    );
  }

  /// Connect the generated [_$TaskFromJson] function to the `fromJson`
  /// factory.
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// Connect the generated [_$TaskToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
