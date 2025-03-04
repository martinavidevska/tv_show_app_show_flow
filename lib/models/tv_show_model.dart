import 'package:flutter/material.dart';

class Show {
  final ShowDetails show;
  final double score;

  Show({required this.show, required this.score});

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(show: ShowDetails.fromJson(json['show']), score: json['score']);
  }
}

class ShowDetails with ChangeNotifier {
  final int id;
  final String name;
  final String? type;
  final String? language;
  final List<String>? genres;
  final String? status;
  final String? premiered;
  final String? ended;
  final ImageDetails? image;
  final String? summary;
  final int? weight;
  final Rating? rating;

  ShowDetails(
      {required this.id,
      required this.name,
      this.type,
      this.language,
      this.genres,
      this.status,
      this.premiered,
      this.ended,
      this.image,
      this.summary,
      this.weight,
      this.rating});

  factory ShowDetails.fromJson(Map<String, dynamic> json) {
    return ShowDetails(
        id: json['id'] ?? 0,
        name: json['name'],
        type: json['type'],
        language: json['language'],
        genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
        status: json['status'],
        premiered: json['premiered'],
        ended: json['ended'],
        image:
            json['image'] != null ? ImageDetails.fromJson(json['image']) : null,
        summary: json['summary'],
        weight: json['weight'],
        rating:
            json['rating'] != null ? Rating.fromJson(json['rating']) : null);
  }
}

class ImageDetails {
  final String medium;
  final String? original;

  ImageDetails({
    required this.medium,
    this.original,
  });

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      medium: json['medium'],
      original: json['original'],
    );
  }
}

class Rating {
  final double? average;

  Rating({this.average});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: json['average'] != null
          ? (json['average'] is int
              ? (json['average'] as int).toDouble()
              : json['average'] as double)
          : null,
    );
  }
}
