import 'package:flutter/material.dart';
import '../models/tv_show_model.dart';

class TVShowProvider with ChangeNotifier {
  List<ShowDetails>  favorites = [];

   void toggleFavorite(ShowDetails show) {
    show.toggleFavorite();
    if (show.isFavorite) {
      favorites.add(show);
    } else {
      favorites.removeWhere((j) => j.id == show.id);
    }
    notifyListeners();
  }

  
}
