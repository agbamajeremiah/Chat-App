class CounterService {
  int _counter = 0;
  int get counter => _counter;

  void singleIncrementCounter() {
    _counter++;
  }

  void doubleIncrementCounter() {
    _counter += 2;
  }
}
