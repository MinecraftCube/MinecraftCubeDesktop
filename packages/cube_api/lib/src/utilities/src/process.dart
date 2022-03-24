import 'dart:io';

/// Auto convert [stderr] and [stdout] to String? If any
///
/// throws [StdoutException] when [exitCode] is not equal to 0
String? transformProcessResult(ProcessResult result) {
  final stderr = result.stderr;
  final stdout = result.stdout;
  String? output;
  if (stderr is String && stderr.isNotEmpty) output = stderr;
  if (stdout is String && stdout.isNotEmpty) output = stdout;
  if (result.exitCode != 0) {
    throw StdoutException(output ?? '');
  }
  return output;
}
