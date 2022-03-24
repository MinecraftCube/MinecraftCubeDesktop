import 'package:equatable/equatable.dart';

class CpuInfo extends Equatable {
  const CpuInfo({
    this.name = '',
    this.load = -1,
  });
  final String name;
  final double load;

  @override
  List<Object?> get props => [name, load];

  CpuInfo copyWith({
    String? name,
    double? load,
  }) {
    return CpuInfo(
      name: name ?? this.name,
      load: load ?? this.load,
    );
  }
}
