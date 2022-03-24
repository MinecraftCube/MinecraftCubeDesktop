import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';

Stream<String> mergeStream(
  Stream<List<int>> streamA,
  Stream<List<int>> streamB, {
  StreamTransformer<List<int>, String>? decoderA,
  StreamTransformer<List<int>, String>? decoderB,
}) {
  return StreamGroup.merge<String>([
    streamA.transform<String>(decoderA ?? utf8.decoder),
    streamB.transform<String>(decoderB ?? utf8.decoder),
  ]);
}
