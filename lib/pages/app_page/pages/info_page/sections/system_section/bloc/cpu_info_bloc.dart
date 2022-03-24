import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:system_repository/system_repository.dart';

abstract class CpuInfoEvent extends Equatable {
  const CpuInfoEvent();
  @override
  List<Object?> get props => [];
}

class CpuInfoStarted extends CpuInfoEvent {
  const CpuInfoStarted();
}

class CpuInfoTicked extends CpuInfoEvent {
  const CpuInfoTicked(this.tick);
  final int tick;

  @override
  List<Object?> get props => [tick];
}

class CpuInfoState extends Equatable {
  const CpuInfoState({
    this.info = const CpuInfo(),
    this.status = NetworkStatus.uninit,
  });
  final CpuInfo info;
  final NetworkStatus status;

  CpuInfoState copyWith({
    CpuInfo? info,
    NetworkStatus? status,
  }) {
    return CpuInfoState(
      info: info ?? this.info,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [info, status];
}

class CpuInfoBloc extends Bloc<CpuInfoEvent, CpuInfoState> {
  CpuInfoBloc({
    required SystemRepository systemRepository,
    required Ticker ticker,
  })  : _systemRepository = systemRepository,
        _ticker = ticker,
        super(const CpuInfoState()) {
    on<CpuInfoStarted>((event, emit) async {
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker.loop(period: 2).listen((event) {
        add(CpuInfoTicked(event));
      });
    });
    on<CpuInfoTicked>((event, emit) async {
      try {
        final info = await _systemRepository.getCpuInfo();
        emit(state.copyWith(status: NetworkStatus.success, info: info));
      } catch (err) {
        emit(state.copyWith(status: NetworkStatus.failure));
      }
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  final SystemRepository _systemRepository;
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
}
