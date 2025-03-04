import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group_project/models/tv_show_model.dart';
import 'package:group_project/providers/tv_show_provider.dart';
import 'package:group_project/widgets/tv_show_grid.dart';
import 'package:group_project/widgets/genre_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> genres = const [
    "All", "Horror", "Romance", "Comedy", "Action", "Drama"
  ];

  @override
  Widget build(BuildContext context) {
    final tvShowProvider = Provider.of<TVShowProvider>(context);

    final List<ShowDetails> displayedShows = 
        tvShowProvider.filteredShows.isNotEmpty
            ? tvShowProvider.filteredShows
            : tvShowProvider.allShows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: genres.map((genre) {
              return GestureDetector(
                onTap: () {
                  if (genre == "All") {
                    tvShowProvider.clearGenreFilter();  
                  } else {
                    tvShowProvider.selectByGenre(genre);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GenreContainer(genre: genre),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: TVShowGrid(shows: displayedShows),
        ),
      ],
    );
  }
}
