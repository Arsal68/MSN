import 'package:flutter/material.dart';

class SubjectProvider extends ChangeNotifier {
  String _selectedSubject = '';

  String get selectedSubject => _selectedSubject;

  void setSubject(String subject) {
    _selectedSubject = subject;
    notifyListeners();
  }
}
