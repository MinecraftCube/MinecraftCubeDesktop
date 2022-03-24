import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/bloc/locale_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockLocaleRepository extends Mock implements LocaleRepository {}

class MockLocale extends Mock implements Locale {}

void main() {
  late LocaleRepository localeRepository;
  late Locale locale;

  setUp(() {
    localeRepository = MockLocaleRepository();
    locale = MockLocale();
  });
  group('LocaleBloc', () {
    test('initial state is correct', () {
      expect(LocaleBloc(localeRepository).state, const LocaleState());
    });

    blocTest<LocaleBloc, LocaleState>(
      'emits [null] when no file',
      build: () => LocaleBloc(
        localeRepository,
      ),
      act: (bloc) => bloc.add(
        LanguageInited(),
      ),
      setUp: () {
        when(() => localeRepository.read()).thenAnswer((_) async => null);
      },
      expect: () {
        verify(() => localeRepository.read()).called(1);
        return const <LocaleState>[LocaleState(locale: null)];
      },
    );

    blocTest<LocaleBloc, LocaleState>(
      'emits [Locale] on init',
      build: () => LocaleBloc(
        localeRepository,
      ),
      act: (bloc) => bloc.add(
        LanguageInited(),
      ),
      setUp: () {
        when(() => locale.languageCode).thenReturn('zh');
        when(() => locale.countryCode).thenReturn('TW');
        when(() => localeRepository.read()).thenAnswer((_) async => locale);
      },
      expect: () {
        verify(() => localeRepository.read()).called(1);
        return <LocaleState>[LocaleState(locale: locale)];
      },
    );

    blocTest<LocaleBloc, LocaleState>(
      'emits [Locale] on changed',
      build: () => LocaleBloc(
        localeRepository,
      ),
      act: (bloc) => bloc.add(
        LanguageChanged(locale),
      ),
      setUp: () {
        when(
          () => localeRepository.write(
            lang: any(named: 'lang'),
            country: any(named: 'country'),
          ),
        ).thenAnswer((_) async => {});
        when(() => locale.languageCode).thenReturn('zh');
        when(() => locale.countryCode).thenReturn('TW');
      },
      expect: () {
        verify(
          () => localeRepository.write(
            lang: any(named: 'lang'),
            country: any(named: 'country'),
          ),
        ).called(1);
        return const <LocaleState>[LocaleState(locale: Locale('zh', 'TW'))];
      },
    );
  });
}
