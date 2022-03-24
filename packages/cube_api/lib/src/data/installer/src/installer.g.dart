// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Installer _$InstallerFromJson(Map<String, dynamic> json) => Installer(
      json['name'] as String,
      json['description'] as String,
      _$enumDecode(_$JarTypeEnumMap, json['type']),
      json['serverPath'] as String,
      mapZipPath: json['mapZipPath'] as String?,
      modelSettings: (json['modelSettings'] as List<dynamic>?)
              ?.map((e) => ModelSetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      modelPack: json['modelPack'] == null
          ? null
          : ModelPack.fromJson(json['modelPack'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InstallerToJson(Installer instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'type': _$JarTypeEnumMap[instance.type],
      'serverPath': instance.serverPath,
      'modelSettings': instance.modelSettings,
      'modelPack': instance.modelPack,
      'mapZipPath': instance.mapZipPath,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$JarTypeEnumMap = {
  JarType.vanilla: 'vanilla',
  JarType.forgeInstaller: 'forgeInstaller',
  JarType.forge: 'forge',
  JarType.unknown: 'unknown',
};
