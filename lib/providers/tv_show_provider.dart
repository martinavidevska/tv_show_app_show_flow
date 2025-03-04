import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/tv_show_model.dart';
import '../services/api_services.dart';

class TVShowProvider with ChangeNotifier {
  List<ShowDetails> allShows = [];
  List<ShowDetails> filteredShows = [];
  bool _isObscure = true;
  bool isLoading = true;
  String? name;
  String? email;
  String? profilePictureUrl;

  Set<int> favoriteIds = {};

  bool get isObscure => _isObscure;

  List<ShowDetails> get favorites =>
      allShows.where((show) => favoriteIds.contains(show.id)).toList();

  void setShows(List<ShowDetails> shows) {
    allShows = shows;
    notifyListeners();
  }

  void toggleFavorite(ShowDetails show) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (favoriteIds.contains(show.id)) {
      favoriteIds.remove(show.id);
    } else {
      favoriteIds.add(show.id);
    }

    _updateFavoritesInFirestore();
    notifyListeners();
  }

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void selectByGenre(String genre) {
    filteredShows = allShows
        .where((show) => show.genres != null && show.genres!.contains(genre))
        .toList();
    notifyListeners();
  }

  void clearGenreFilter() {
    filteredShows = [];
    notifyListeners();
  }

  Future<void> loadShowsAndFavorites() async {
    isLoading = true;
    notifyListeners();

    final shows = await ApiService.getShowByIndex(200);
    shows.sort((a, b) => (b.weight ?? 0).compareTo(a.weight ?? 0));

    setShows(shows);

    await fetchFavorites();

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      print("the favorite shows ids are ");
      print(data?['favorites']);

      if (data != null && data['favorites'] != null) {
        favoriteIds = Set<int>.from(data['favorites'] ?? []);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }

  Future<void> _updateFavoritesInFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'favorites': favoriteIds.toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating favorites: $e");
    }
  }

  void reset() {
    allShows = [];
    filteredShows = [];
    favoriteIds.clear();
    name = null;
    email = null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfilePicture(String downloadUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    profilePictureUrl = downloadUrl;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profilePictureUrl': downloadUrl,
      }, SetOptions(merge: true)); 
    } catch (e) {
      print("Error saving profile picture URL to Firestore: $e");
    }
  }

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      email = currentUser.email;

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (doc.exists) {
          name = doc['name'] ?? 'Unknown';
          profilePictureUrl = doc['profilePictureUrl'];
        } else {
          name = 'Unknown';
          profilePictureUrl = null;
        }
      } catch (e) {
        print("Error fetching user data: $e");
        name = 'Unknown';
        profilePictureUrl = null;
      }
    } else {
      name = 'Guest';
      email = 'Not logged in';
      profilePictureUrl = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
