import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:locale_repository/locale_repository.dart';

import 'package:minecraft_cube_desktop/_consts/localization.dart';

abstract class LocaleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LanguageChanged extends LocaleEvent {
  final Locale locale;
  LanguageChanged(this.locale);

  @override
  List<Object> get props => [locale.name];
}

class LanguageInited extends LocaleEvent {
  @override
  List<Object> get props => [];
}

class LocaleState extends Equatable {
  const LocaleState({
    this.locale,
  });
  final Locale? locale;

  @override
  List<Object> get props => [locale?.name ?? ''];

  LocaleState copyWith({
    Locale? locale,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }
}

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc(this._localeRepository) : super(const LocaleState()) {
    on<LanguageChanged>((event, emit) async {
      await _localeRepository.write(
        lang: event.locale.languageCode,
        country: event.locale.countryCode ?? '',
      );
      emit(state.copyWith(locale: event.locale));
    });
    on<LanguageInited>((event, emit) async {
      emit(state.copyWith(locale: await _localeRepository.read()));
    });
  }

  final LocaleRepository _localeRepository;
}
