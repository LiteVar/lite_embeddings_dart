import 'package:json_annotation/json_annotation.dart';

part 'exception.g.dart';

@JsonSerializable(createFactory: false)
class VectorDatabaseException implements Exception {
  final int code;
  final String message;

  VectorDatabaseException({
    required this.code,
    required this.message,
  });

  Map<String, dynamic> toJson() => _$VectorDatabaseExceptionToJson(this);
}