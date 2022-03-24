import 'dart:convert';
import 'dart:ui';

import 'package:ansi_up/ansi_up.dart';
import 'package:equatable/equatable.dart';

class ConsoleLine extends Equatable {
  final Iterable<ConsoleText> texts;
  const ConsoleLine({
    required this.texts,
  });

  ConsoleLine copyWith({
    Iterable<ConsoleText>? texts,
  }) {
    return ConsoleLine(
      texts: texts ?? this.texts,
    );
  }

  @override
  List<Object> get props => [texts];
}

class ConsoleText extends Equatable {
  final Color? foreground;
  final Color? background;
  final bool bold;
  final String text;
  const ConsoleText({
    this.foreground,
    this.background,
    this.bold = false,
    required this.text,
  });

  @override
  List<Object?> get props => [foreground, background, bold, text];

  ConsoleText copyWith({
    Color? foreground,
    Color? background,
    bool? bold,
    String? text,
  }) {
    return ConsoleText(
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      bold: bold ?? this.bold,
      text: text ?? this.text,
    );
  }
}

class ConsoleRepository {
  ConsoleRepository([
    AnsiUp? ansiUp,
  ]) : _ansiUp = ansiUp ?? AnsiUp();
  final AnsiUp _ansiUp;

  Iterable<ConsoleLine> parse(String text) sync* {
    final lines = const LineSplitter().convert(text);
    if (lines.isEmpty) return;
    for (final line in lines) {
      final parseResults = decodeAnsiColorEscapeCodes(line, _ansiUp);
      yield ConsoleLine(
        texts: parseResults.map(
          (e) => ConsoleText(
            bold: e.bold,
            text: e.text,
            foreground: _colorFromAnsi(e.fgColor),
            background: _colorFromAnsi(e.bgColor),
          ),
        ),
      );
    }
  }

  Color? _colorFromAnsi(List<int>? ansiInput) {
    if (ansiInput == null) return null;
    assert(ansiInput.length == 3, 'Ansi color list should contain 3 elements');
    return Color.fromRGBO(ansiInput[0], ansiInput[1], ansiInput[2], 1);
  }
}
