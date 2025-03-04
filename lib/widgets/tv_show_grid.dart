import 'package:flutter/material.dart';
import 'package:group_project/models/tv_show_model.dart';
import 'package:group_project/widgets/tv_show_card.dart';

class TVShowGrid extends StatelessWidget {
  final List<ShowDetails> shows;

  const TVShowGrid({super.key, required this.shows});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF273343),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemCount: shows.length,
        itemBuilder: (context, index) {
          final show = shows[index];
          return TVShowCard(show: show);
        },
      ),
    );
  }
}
