import 'package:flutter/material.dart';

class GenreContainer extends StatelessWidget {
  final String genre;

  const GenreContainer({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF273343), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 115, 126, 139), 
          width: 1,
        ),
      ),
      child: Text(
        genre,
        style: TextStyle(
          color: Colors.grey[300], 
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
