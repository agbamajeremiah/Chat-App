import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class BaseModel with ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = !_busy;
    notifyListeners();
  }
}
