import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class StateService with ReactiveServiceMixin {
  StateService() {
    listenToReactiveValues([_rebuildPage]);
  }
  //Reactive Value
  RxValue<bool> _rebuildPage = RxValue(initial: false);
  bool get rebuildPage => _rebuildPage.value;
  //FXN to update all reactive pages
  void updatePages() {
    _rebuildPage.value = !_rebuildPage.value;
  }
}
