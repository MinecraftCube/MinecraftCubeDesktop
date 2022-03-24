import 'package:equatable/equatable.dart';

abstract class CommonProperty extends Equatable {
  final String name;
  final String description;
  final String fieldName;
  const CommonProperty({
    required this.name,
    required this.description,
    required this.fieldName,
  });

  @override
  List<Object> get props {
    final property = this;
    final List<Object> compares = [name, description, fieldName];
    if (property is IntegerServerProperty) {
      compares.add(property.value);
      compares.add(property.selectables);
    } else if (property is StringServerProperty) {
      compares.add(property.value);
    } else if (property is BoolServerProperty) {
      compares.add(property.value);
    }

    return compares;
  }
}

class IntegerServerProperty extends CommonProperty {
  final int value;
  final Map<int, String> selectables;

  const IntegerServerProperty({
    required String name,
    required String description,
    required String fieldName,
    required this.value,
    this.selectables = const {},
  }) : super(name: name, description: description, fieldName: fieldName);

  @override
  List<Object> get props => [super.props, value, selectables];

  IntegerServerProperty copyWith({
    String? name,
    String? description,
    String? fieldName,
    int? value,
    Map<int, String>? selectables,
  }) {
    return IntegerServerProperty(
      name: name ?? this.name,
      description: description ?? this.description,
      fieldName: fieldName ?? this.fieldName,
      value: value ?? this.value,
      selectables: selectables ?? this.selectables,
    );
  }
}

class StringServerProperty extends CommonProperty {
  final String value;
  final Map<String, String> selectables;

  const StringServerProperty({
    required String name,
    required String description,
    required String fieldName,
    required this.value,
    this.selectables = const {},
  }) : super(name: name, description: description, fieldName: fieldName);

  @override
  List<Object> get props => [super.props, value, selectables];

  StringServerProperty copyWith({
    String? name,
    String? description,
    String? fieldName,
    String? value,
    Map<String, String>? selectables,
  }) {
    return StringServerProperty(
      name: name ?? this.name,
      description: description ?? this.description,
      fieldName: fieldName ?? this.fieldName,
      value: value ?? this.value,
      selectables: selectables ?? this.selectables,
    );
  }
}

class BoolServerProperty extends CommonProperty {
  final bool value;

  const BoolServerProperty({
    required String name,
    required String description,
    required String fieldName,
    required this.value,
  }) : super(name: name, description: description, fieldName: fieldName);

  @override
  List<Object> get props => [super.props, value];

  BoolServerProperty copyWith({
    String? name,
    String? description,
    String? fieldName,
    bool? value,
  }) {
    return BoolServerProperty(
      name: name ?? this.name,
      description: description ?? this.description,
      fieldName: fieldName ?? this.fieldName,
      value: value ?? this.value,
    );
  }
}
