import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favoriteJokes = [];

  List<Map<String, dynamic>> get favoriteJokes => _favoriteJokes;

  void toggleFavorite(Map<String, dynamic> joke) {
    if (_favoriteJokes.contains(joke)) {
      _favoriteJokes.remove(joke);
    } else {
      _favoriteJokes.add(joke);
    }
    notifyListeners();
  }
}
