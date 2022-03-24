class Ticker {
  const Ticker();
  Stream<int> loop({required int period}) {
    return Stream<int>.periodic(Duration(seconds: period), (x) => x);
  }
}
