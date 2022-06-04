import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/consts/app_cube_properties.dart';
import 'package:collection/collection.dart';

abstract class CubePropertiesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CubePropertiesLoaded extends CubePropertiesEvent {}

class CubePropertiesSaved extends CubePropertiesEvent {}

class CubePropertiesChanged extends CubePropertiesEvent {
  final String fieldName;
  final dynamic value;
  CubePropertiesChanged({
    required this.fieldName,
    required this.value,
  });

  @override
  List<Object?> get props => [fieldName, value];
}

class CubePropertiesState extends Equatable {
  const CubePropertiesState({
    this.properties = const [],
    this.status = NetworkStatus.uninit,
  });

  final List<CommonProperty> properties;
  final NetworkStatus status;

  @override
  List<Object> get props => [properties, status];

  CubePropertiesState copyWith({
    List<CommonProperty>? properties,
    NetworkStatus? status,
  }) {
    return CubePropertiesState(
      properties: properties ?? this.properties,
      status: status ?? this.status,
    );
  }
}

class CubePropertiesBloc
    extends Bloc<CubePropertiesEvent, CubePropertiesState> {
  CubePropertiesBloc({
    required this.cubePropertiesRepository,
    required this.javaInfoRepository,
    required this.projectPath,
  }) : super(const CubePropertiesState()) {
    on<CubePropertiesLoaded>(_onCubePropertiesLoaded);
    on<CubePropertiesSaved>(_onCubePropertiesSaved);
    on<CubePropertiesChanged>(_onCubePropertiesChanged);
  }

  final CubePropertiesRepository cubePropertiesRepository;
  final JavaInfoRepository javaInfoRepository;
  final String projectPath;

  Future<void> _onCubePropertiesLoaded(
    CubePropertiesLoaded event,
    Emitter<CubePropertiesState> emit,
  ) async {
    List<CommonProperty> properties = [];
    final appProperties = getAppCubeProperties().toList();

    await for (final localProperty
        in cubePropertiesRepository.getProperties(directory: projectPath)) {
      final predefinedCubeProp = appProperties.firstWhereOrNull(
        (element) => element.fieldName == localProperty.name,
      );
      if (predefinedCubeProp != null) {
        if (predefinedCubeProp is StringServerProperty) {
          properties
              .add(predefinedCubeProp.copyWith(value: localProperty.value));
        } else if (predefinedCubeProp is IntegerServerProperty) {
          final value = int.tryParse(localProperty.value);
          properties.add(predefinedCubeProp.copyWith(value: value));
        } else if (predefinedCubeProp is BoolServerProperty) {
          final value = localProperty.value.toLowerCase() == 'true';
          properties.add(predefinedCubeProp.copyWith(value: value));
        }
        appProperties.remove(predefinedCubeProp);
      } else {
        properties.add(
          StringServerProperty(
            name: localProperty.name,
            description: '',
            fieldName: localProperty.name,
            value: localProperty.value,
          ),
        );
      }
    }

    for (final commonProp in appProperties) {
      if (commonProp is StringServerProperty) {
        properties.add(commonProp);
      } else if (commonProp is IntegerServerProperty) {
        properties.add(commonProp);
      } else if (commonProp is BoolServerProperty) {
        properties.add(commonProp);
      }
    }

    Map<String, String> nameToPathMap = {};
    await for (final info in javaInfoRepository.getPortableJavas()) {
      nameToPathMap[info.name] = info.executablePaths.first;
    }

    for (int i = 0; i < properties.length; i++) {
      if (properties[i].fieldName == 'Java') {
        final javaProperty = properties[i] as StringServerProperty;
        properties[i] = javaProperty.copyWith(
          selectables: nameToPathMap..addAll(javaProperty.selectables),
        );
      }
    }

    emit(state.copyWith(properties: properties));
  }

  Future<void> _onCubePropertiesChanged(
    CubePropertiesChanged event,
    Emitter<CubePropertiesState> emit,
  ) async {
    final currentProperties = state.properties.toList();
    final currentPropertyIndex = currentProperties.indexWhere(
      (element) => element.fieldName == event.fieldName,
    );
    final currentProperty = currentProperties[currentPropertyIndex];
    if (currentPropertyIndex != -1) {
      if (currentProperty is StringServerProperty) {
        currentProperties[currentPropertyIndex] =
            currentProperty.copyWith(value: event.value);
      } else if (currentProperty is IntegerServerProperty) {
        currentProperties[currentPropertyIndex] =
            currentProperty.copyWith(value: event.value);
      } else if (currentProperty is BoolServerProperty) {
        currentProperties[currentPropertyIndex] =
            currentProperty.copyWith(value: event.value);
      }
    }
    emit(state.copyWith(properties: currentProperties));
  }

  Future<void> _onCubePropertiesSaved(
    CubePropertiesSaved event,
    Emitter<CubePropertiesState> emit,
  ) async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    final List<Property> props = [];
    for (final serverProp in state.properties) {
      if (serverProp is StringServerProperty) {
        props
            .add(Property(name: serverProp.fieldName, value: serverProp.value));
      } else if (serverProp is IntegerServerProperty) {
        props.add(
          Property(
            name: serverProp.fieldName,
            value: serverProp.value.toString(),
          ),
        );
      } else if (serverProp is BoolServerProperty) {
        props.add(
          Property(
            name: serverProp.fieldName,
            value: serverProp.value.toString(),
          ),
        );
      }
    }
    try {
      await cubePropertiesRepository.saveProperties(
        directory: projectPath,
        properties: props,
      );
      emit(state.copyWith(status: NetworkStatus.success));
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }
}
