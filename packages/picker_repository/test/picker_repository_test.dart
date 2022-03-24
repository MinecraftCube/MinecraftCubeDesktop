import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:picker_repository/picker_repository.dart';

class MockFilePicker extends Mock implements FilePicker {}

class MockFilePickerResult extends Mock implements FilePickerResult {}

void main() {
  setUpAll(() {
    // registerFallbackValue(FilePickerStatus);
    registerFallbackValue(FileType.any);
  });
  group('PickerRepository', () {
    late FilePicker filePicker;
    late PickerRepository repository;

    setUp(() {
      filePicker = MockFilePicker();
      repository = PickerRepository(
        filePicker: filePicker,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(PickerRepository(), isNotNull);
      });
    });

    group('selectFile', () {
      test('call pickFiles but bad result', () async {
        FilePickerResult? result;
        when(
          () => filePicker.pickFiles(
            dialogTitle: any(named: 'dialogTitle'),
            initialDirectory: any(named: 'initialDirectory'),
            type: any(named: 'type'),
            allowedExtensions: any(named: 'allowedExtensions'),
            onFileLoading: any(named: 'onFileLoading'),
            allowCompression: any(named: 'allowCompression'),
            allowMultiple: any(named: 'allowMultiple'),
            withData: any(named: 'withData'),
            withReadStream: any(named: 'withReadStream'),
            lockParentWindow: any(named: 'lockParentWindow'),
          ),
        ).thenAnswer((_) async => result);
        expect(
          await repository.selectFile(),
          isNull,
        );
        verify(
          () => filePicker.pickFiles(
            dialogTitle: any(named: 'dialogTitle'),
            initialDirectory: any(named: 'initialDirectory'),
            type: any(named: 'type'),
            allowedExtensions: any(named: 'allowedExtensions'),
            onFileLoading: any(named: 'onFileLoading'),
            allowCompression: any(named: 'allowCompression'),
            allowMultiple: any(named: 'allowMultiple'),
            withData: any(named: 'withData'),
            withReadStream: any(named: 'withReadStream'),
            lockParentWindow: any(named: 'lockParentWindow'),
          ),
        ).called(1);
      });
      test('call pickFiles but good result', () async {
        FilePickerResult result = MockFilePickerResult();
        when(
          () => filePicker.pickFiles(
            dialogTitle: any(named: 'dialogTitle'),
            initialDirectory: any(named: 'initialDirectory'),
            type: any(named: 'type'),
            allowedExtensions: any(named: 'allowedExtensions'),
            onFileLoading: any(named: 'onFileLoading'),
            allowCompression: any(named: 'allowCompression'),
            allowMultiple: any(named: 'allowMultiple'),
            withData: any(named: 'withData'),
            withReadStream: any(named: 'withReadStream'),
            lockParentWindow: any(named: 'lockParentWindow'),
          ),
        ).thenAnswer((_) async => result);
        expect(
          await repository.selectFile(),
          isNotNull,
        );
      });
    });
  });
}
