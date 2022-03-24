import 'package:cube_api/src/ticker/ticker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ticker', () {
    const ticker = Ticker();
    group('loop', () {
      test('ticker emits 3 ticks from 6 seconds with period of 2', () async {
        int counter = 0;
        final sub = ticker.loop(period: 2).listen(((_) => counter++));
        await Future.delayed(const Duration(seconds: 7));
        await sub.cancel();
        expect(counter, 3);
      });
      test('ticker emits 2 ticks from 6 seconds with period of 3', () async {
        int counter = 0;
        final sub = ticker.loop(period: 3).listen(((_) => counter++));
        await Future.delayed(const Duration(seconds: 7));
        await sub.cancel();
        expect(counter, 2);
      });
    });
  });
}
