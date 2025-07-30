import 'package:flutter/material.dart';

class DemoProvider with ChangeNotifier {
  int _count = 0;
  int _age = 0;

  void increaseCount() {
    _count++;
    _age++;
    print("counter $_count");
    print("age $_age");
    notifyListeners();
  }

  void decreaseCount() {
    _count--;
    _age--;
    print("counter $_count");
    print("age $_age");
    notifyListeners();
  }

  void increaseAge() {
    _age++;
    print("age $_age");
    notifyListeners();
  }

  int get count => _count;
}
