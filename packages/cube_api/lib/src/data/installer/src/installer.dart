import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'installer.g.dart';

@JsonSerializable()
class Installer extends Equatable {
  const Installer(
    this.name,
    this.description,
    this.type,
    this.serverPath, {
    this.mapZipPath,
    this.modelSettings = const [],
    this.modelPack,
  });

  final String name;
  final String description;
  final JarType type;
  final String serverPath;
  final List<ModelSetting> modelSettings;
  final ModelPack? modelPack;
  final String? mapZipPath;

  factory Installer.fromJson(Map<String, dynamic> json) =>
      _$InstallerFromJson(json);

  Map<String, dynamic> toJson() => _$InstallerToJson(this);

  Installer copyWith({
    String? name,
    String? description,
    JarType? type,
    String? serverPath,
    List<ModelSetting>? modelSettings,
    ModelPack? modelPack,
    String? mapZipPath,
  }) {
    return Installer(
      name ?? this.name,
      description ?? this.description,
      type ?? this.type,
      serverPath ?? this.serverPath,
      modelSettings: modelSettings ?? this.modelSettings,
      modelPack: modelPack ?? this.modelPack,
      mapZipPath: mapZipPath ?? this.mapZipPath,
    );
  }

  @override
  List<Object?> get props {
    return [
      name,
      description,
      type,
      serverPath,
      modelSettings,
      modelPack,
      mapZipPath,
    ];
  }
}
