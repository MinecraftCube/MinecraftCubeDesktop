import 'package:console_repository/console_repository.dart';

Iterable<ConsoleLine> generateOneLineConsoleLine(String text) {
  return [
    ConsoleLine(
      texts: [
        ConsoleText(
          text: text,
        )
      ],
    )
  ];
}
