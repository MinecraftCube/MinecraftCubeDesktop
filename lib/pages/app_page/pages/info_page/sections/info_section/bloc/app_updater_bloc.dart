import 'package:app_updater_repository/app_updater_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';

import 'package:minecraft_cube_desktop/_gen/version.gen.dart';

abstract class AppUpdaterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppUpdaterStarted extends AppUpdaterEvent {}

class AppUpdaterMarkdownFetched extends AppUpdaterEvent {
  final String fullLocale;
  AppUpdaterMarkdownFetched({
    required this.fullLocale,
  });

  @override
  List<Object?> get props => [fullLocale];
}

class AppUpdaterState extends Equatable {
  const AppUpdaterState({
    this.markdown = '',
    this.hasGreaterVersion = false,
    this.status = NetworkStatus.uninit,
  });
  final String markdown;
  final bool hasGreaterVersion;
  final NetworkStatus status;

  @override
  List<Object> get props => [markdown, hasGreaterVersion, status];

  AppUpdaterState copyWith({
    String? markdown,
    bool? hasGreaterVersion,
    NetworkStatus? status,
  }) {
    return AppUpdaterState(
      markdown: markdown ?? this.markdown,
      hasGreaterVersion: hasGreaterVersion ?? this.hasGreaterVersion,
      status: status ?? this.status,
    );
  }
}

class AppUpdaterBloc extends Bloc<AppUpdaterEvent, AppUpdaterState> {
  AppUpdaterBloc({required this.appUpdaterRepository})
      : super(const AppUpdaterState()) {
    on<AppUpdaterStarted>(_onAppUpdaterStarted);
    on<AppUpdaterMarkdownFetched>(_onAppUpdaterMarkdownFetched);
  }
  final AppUpdaterRepository appUpdaterRepository;

  Future<void> _onAppUpdaterStarted(
    AppUpdaterStarted event,
    Emitter<AppUpdaterState> emit,
  ) async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final hasGreaterVersion =
          await appUpdaterRepository.hasGreaterVersion(version: packageVersion);
      emit(
        state.copyWith(
          status: NetworkStatus.success,
          hasGreaterVersion: hasGreaterVersion,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }

  Future<void> _onAppUpdaterMarkdownFetched(
    AppUpdaterMarkdownFetched event,
    Emitter<AppUpdaterState> emit,
  ) async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final markdown = await appUpdaterRepository.getLatestRelease(
        fullLocale: event.fullLocale,
      );
      emit(
        state.copyWith(
          status: NetworkStatus.success,
          markdown: markdown,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }
  }
}
