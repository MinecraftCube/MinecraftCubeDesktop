import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String name;
  final String value;

  const Property({
    required this.name,
    required this.value,
  });

  Property copyWith({
    String? name,
    String? value,
  }) {
    return Property(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [name, value];
}
