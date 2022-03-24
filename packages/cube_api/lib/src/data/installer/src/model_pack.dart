import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_pack.g.dart';

@JsonSerializable()
class ModelPack extends Equatable {
  const ModelPack({
    required this.path,
    this.description,
  });
  final String path;
  final String? description;

  factory ModelPack.fromJson(Map<String, dynamic> json) =>
      _$ModelPackFromJson(json);

  Map<String, dynamic> toJson() => _$ModelPackToJson(this);

  ModelPack copyWith({
    String? path,
    String? description,
  }) {
    return ModelPack(
      path: path ?? this.path,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [path, description];
}
