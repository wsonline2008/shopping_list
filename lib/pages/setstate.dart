import 'package:flutter/material.dart';

class SetState with ChangeNotifier {
  bool _isFresh;
  SetState(this._isFresh);
  void fresh(bool newValue) {
    _isFresh=newValue;
    notifyListeners();
  }
  get isFresh => _isFresh;
}