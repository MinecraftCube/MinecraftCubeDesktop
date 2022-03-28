import 'package:app_updater_repository/app_updater_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  group('AppUpdaterRepository', () {
    late Dio dio;
    late AppUpdaterRepository repository;

    setUp(() {
      dio = MockDio();
      repository = AppUpdaterRepository(
        dio: dio,
      );
    });

    group('constructor', () {
      test('instantiates internal Dio when not injected', () {
        expect(AppUpdaterRepository(), isNotNull);
      });
    });

    group('hasGreaterVersion', () {
      test('throws FormatException by invalid input', () async {
        expect(
          () => repository.hasGreaterVersion(version: '1asdaskjaskl'),
          throwsFormatException,
        );
      });

      test('throws DioError by wrong github fetching', () async {
        when(() => dio.get(captureAny()))
            .thenThrow(DioError(requestOptions: RequestOptions(path: '')));
        expect(
          () => repository.hasGreaterVersion(version: '1.2.3'),
          throwsA(isA<DioError>()),
        );

        expect(
          verify(() => dio.get(captureAny())).captured,
          [
            'https://raw.githubusercontent.com/MinecraftCube/MinecraftCubeDesktop/version_info/version'
          ],
        );
      });

      test('return false when data is null', () async {
        final Response<String> response = MockResponse<String>();
        when(() => dio.get(any())).thenAnswer((_) async => response);
        when(() => response.data).thenReturn(null);

        expect(
          await repository.hasGreaterVersion(version: '1.2.3'),
          isFalse,
        );
      });

      test('throws FormatException by unexpected online version', () async {
        final Response<String> response = MockResponse<String>();
        when(() => dio.get(any())).thenAnswer((_) async => response);
        when(() => response.data).thenReturn('sakjdasksaj');

        expect(
          () => repository.hasGreaterVersion(version: '1asdaskjaskl'),
          throwsFormatException,
        );
      });

      test('return true when online version is greater than app version',
          () async {
        final Response<String> response = MockResponse<String>();
        when(() => dio.get(any())).thenAnswer((_) async => response);
        when(() => response.data).thenReturn('1.2.4');

        expect(
          await repository.hasGreaterVersion(version: '1.2.3'),
          isTrue,
        );
      });
    });

    group('getLatestRelease', () {
      test(
        'throws DioError when there is no release note for specified country&lang.',
        () {
          when(() => dio.get(captureAny()))
              .thenThrow(DioError(requestOptions: RequestOptions(path: '')));
          expect(
            () => repository.getLatestRelease(fullLocale: 'test'),
            throwsA(isA<DioError>()),
          );
        },
      );

      test(
        'return null',
        () async {
          final Response<String> response = MockResponse<String>();
          when(() => dio.get(any())).thenAnswer((_) async => response);
          when(() => response.data).thenReturn(null);
          expect(
            await repository.getLatestRelease(fullLocale: 'test'),
            isNull,
          );
        },
      );

      test(
        'return content',
        () async {
          final Response<String> response = MockResponse<String>();
          when(() => dio.get(any())).thenAnswer((_) async => response);
          when(() => response.data).thenReturn('markdownContent');
          expect(
            await repository.getLatestRelease(fullLocale: 'test'),
            'markdownContent',
          );
        },
      );
    });
  });
}
