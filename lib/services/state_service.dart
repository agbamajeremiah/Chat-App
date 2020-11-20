import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class StateService with ReactiveServiceMixin {
  // int _rebuildPage = 0;
  StateService() {
    listenToReactiveValues([_rebuildPage]);
  }
  RxValue<bool> _rebuildPage = RxValue(initial: false);
  bool get rebuildPage => _rebuildPage.value;

  void updatePages() {
    _rebuildPage.value = !_rebuildPage.value;
  }
}
