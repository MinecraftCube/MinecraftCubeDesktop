import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:system_repository/system_repository.dart';

abstract class MemoryInfoEvent extends Equatable {
  const MemoryInfoEvent();
  @override
  List<Object?> get props => [];
}

class MemoryInfoStarted extends MemoryInfoEvent {
  const MemoryInfoStarted();
}

class MemoryInfoTicked extends MemoryInfoEvent {
  const MemoryInfoTicked(this.tick);
  final int tick;

  @override
  List<Object?> get props => [tick];
}

class MemoryInfoState extends Equatable {
  const MemoryInfoState({
    this.info = const MemoryInfo(),
    this.status = NetworkStatus.uninit,
  });
  final MemoryInfo info;
  final NetworkStatus status;

  MemoryInfoState copyWith({
    MemoryInfo? info,
    NetworkStatus? status,
  }) {
    return MemoryInfoState(
      info: info ?? this.info,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [info, status];
}

class MemoryInfoBloc extends Bloc<MemoryInfoEvent, MemoryInfoState> {
  MemoryInfoBloc({
    required SystemRepository systemRepository,
    required Ticker ticker,
  })  : _systemRepository = systemRepository,
        _ticker = ticker,
        super(const MemoryInfoState()) {
    on<MemoryInfoStarted>((event, emit) async {
      _tickerSubscription?.cancel();
      _tickerSubscription = _ticker.loop(period: 2).listen((event) {
        add(MemoryInfoTicked(event));
      });
    });
    on<MemoryInfoTicked>((event, emit) async {
      try {
        final info = await _systemRepository.getMemoryInfo();
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
