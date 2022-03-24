import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:system_repository/system_repository.dart';

abstract class GpuInfoEvent extends Equatable {
  const GpuInfoEvent();
  @override
  List<Object?> get props => [];
}

class GpuInfoStarted extends GpuInfoEvent {
  const GpuInfoStarted();
}

class GpuInfoState extends Equatable {
  const GpuInfoState({
    this.info = '',
    this.status = NetworkStatus.uninit,
  });
  final String info;
  final NetworkStatus status;

  GpuInfoState copyWith({
    String? info,
    NetworkStatus? status,
  }) {
    return GpuInfoState(
      info: info ?? this.info,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [info, status];
}

class GpuInfoBloc extends Bloc<GpuInfoEvent, GpuInfoState> {
  GpuInfoBloc({
    required SystemRepository systemRepository,
  })  : _systemRepository = systemRepository,
        super(const GpuInfoState()) {
    on<GpuInfoStarted>((event, emit) async {
      emit(state.copyWith(status: NetworkStatus.inProgress));
      try {
        final info = await _systemRepository.getGpuInfo();
        emit(state.copyWith(status: NetworkStatus.success, info: info));
      } catch (_) {
        emit(state.copyWith(status: NetworkStatus.failure));
      }
    });
  }

  final SystemRepository _systemRepository;
}
