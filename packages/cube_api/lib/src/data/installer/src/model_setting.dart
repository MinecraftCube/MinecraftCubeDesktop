import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_setting.g.dart';

@JsonSerializable()
class ModelSetting extends Equatable {
  const ModelSetting({
    required this.name,
    required this.program,
    required this.path,
  });
  final String name;
  final String program;
  final String path;

  factory ModelSetting.fromJson(Map<String, dynamic> json) =>
      _$ModelSettingFromJson(json);

  Map<String, dynamic> toJson() => _$ModelSettingToJson(this);

  @override
  List<Object> get props => [name, program, path];

  ModelSetting copyWith({
    String? name,
    String? program,
    String? path,
  }) {
    return ModelSetting(
      name: name ?? this.name,
      program: program ?? this.program,
      path: path ?? this.path,
    );
  }
}
