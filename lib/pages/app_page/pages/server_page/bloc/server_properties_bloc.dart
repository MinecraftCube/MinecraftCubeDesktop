import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/consts/app_server_properties.dart';
import 'package:server_properties_repository/server_properties_repository.dart';
import 'package:collection/collection.dart';

abstract class ServerPropertiesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerPropertiesLoaded extends ServerPropertiesEvent {}

class ServerPropertiesSaved extends ServerPropertiesEvent {}

class ServerPropertiesChanged extends ServerPropertiesEvent {
  final String fieldName;
  final dynamic value;
  ServerPropertiesChanged({
    required this.fieldName,
    required this.value,
  });

  @override
  List<Object?> get props => [fieldName, value];
}

class ServerPropertiesState extends Equatable {
  const ServerPropertiesState({
    this.properties = const [],
    this.status = NetworkStatus.uninit,
  });

  final List<CommonProperty> properties;
  final NetworkStatus status;

  @override
  List<Object> get props => [properties, status];

  ServerPropertiesState copyWith({
    List<CommonProperty>? properties,
    NetworkStatus? status,
  }) {
    return ServerPropertiesState(
      properties: properties ?? this.properties,
      status: status ?? this.status,
    );
  }
}

class ServerPropertiesBloc
    extends Bloc<ServerPropertiesEvent, ServerPropertiesState> {
  ServerPropertiesBloc({
    required this.serverPropertiesRepository,
    required this.projectPath,
  }) : super(const ServerPropertiesState()) {
    on<ServerPropertiesLoaded>(_onServerPropertiesLoaded);
    on<ServerPropertiesSaved>(_onServerPropertiesSaved);
    on<ServerPropertiesChanged>(_onServerPropertiesChanged);
  }

  final ServerPropertiesRepository serverPropertiesRepository;
  final String projectPath;

  Future<void> _onServerPropertiesLoaded(
    ServerPropertiesLoaded event,
    Emitter<ServerPropertiesState> emit,
  ) async {
    List<CommonProperty> properties = [];
    final appProperties = getAppServerProperties().toList();
    await for (final localProperty
        in serverPropertiesRepository.getProperties(directory: projectPath)) {
      final predefinedServerProp = appProperties.firstWhereOrNull(
        (element) => element.fieldName == localProperty.name,
      );
      if (predefinedServerProp != null) {
        if (predefinedServerProp is StringServerProperty) {
          properties
              .add(predefinedServerProp.copyWith(value: localProperty.value));
        } else if (predefinedServerProp is IntegerServerProperty) {
          final value = int.tryParse(localProperty.value);
          properties.add(predefinedServerProp.copyWith(value: value));
        } else if (predefinedServerProp is BoolServerProperty) {
          final value = localProperty.value.toLowerCase() == 'true';
          properties.add(predefinedServerProp.copyWith(value: value));
        }
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
    emit(state.copyWith(properties: properties));
  }

  Future<void> _onServerPropertiesChanged(
    ServerPropertiesChanged event,
    Emitter<ServerPropertiesState> emit,
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

  Future<void> _onServerPropertiesSaved(
    ServerPropertiesSaved event,
    Emitter<ServerPropertiesState> emit,
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
      await serverPropertiesRepository.saveProperties(
        directory: projectPath,
        properties: props,
      );
      emit(state.copyWith(status: NetworkStatus.success));
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }
}
