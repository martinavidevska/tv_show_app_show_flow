import 'package:flutter/material.dart';
import 'package:group_project/widgets/tv_show_grid.dart';
import 'package:provider/provider.dart';
import '../providers/tv_show_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteShows = Provider.of<TVShowProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorite Shows',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF273343),
      ),
      backgroundColor: const Color(0xFF273343),
      body: favoriteShows.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet, or not logged in!',
                style: TextStyle(color: Colors.white),
              ),
            )
          : TVShowGrid(shows: favoriteShows),  
    );
  }
}
