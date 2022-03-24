import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';
import 'package:network_repository/network_repository.dart';

abstract class NetworkInternalIpEvent extends Equatable {
  const NetworkInternalIpEvent();
  @override
  List<Object?> get props => [];
}

class NetworkInternalIpStarted extends NetworkInternalIpEvent {
  const NetworkInternalIpStarted();
}

class NetworkInternalIpState extends Equatable {
  const NetworkInternalIpState({
    this.ips = const [],
    this.status = NetworkStatus.uninit,
  });
  final List<NetworkInterface> ips;
  final NetworkStatus status;

  NetworkInternalIpState copyWith({
    List<NetworkInterface>? ips,
    NetworkStatus? status,
  }) {
    return NetworkInternalIpState(
      ips: ips ?? this.ips,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props {
    final stringify = ips
        .map<String>((e) => e.name + e.addresses.map((e) => e.address).join())
        .join();
    return [stringify, status];
  }
}

class NetworkInternalIpBloc
    extends Bloc<NetworkInternalIpEvent, NetworkInternalIpState> {
  NetworkInternalIpBloc({required NetworkRepository networkRepository})
      : _networkRepository = networkRepository,
        super(const NetworkInternalIpState()) {
    on<NetworkInternalIpStarted>((event, emit) async {
      emit(state.copyWith(status: NetworkStatus.inProgress));
      try {
        final ips = await _networkRepository.getInternalIps();
        emit(state.copyWith(status: NetworkStatus.success, ips: ips));
      } catch (err) {
        emit(state.copyWith(status: NetworkStatus.failure, ips: []));
      }
    });
  }

  final NetworkRepository _networkRepository;
}
