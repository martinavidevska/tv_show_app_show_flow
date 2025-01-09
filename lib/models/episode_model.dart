class Episode {
  final int id;
  final String url;
  final String name;
  final int season;
  final int number;
  final String type;
  final String airdate;
  final String airtime;
  final int runtime;
  final Rating rating;
  final ImageDetails image;
  final String summary;

  Episode({
    required this.id,
    required this.url,
    required this.name,
    required this.season,
    required this.number,
    required this.type,
    required this.airdate,
    required this.airtime,
    required this.runtime,
    required this.rating,
    required this.image,
    required this.summary,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      season: json['season'],
      number: json['number'],
      type: json['type'],
      airdate: json['airdate'],
      airtime: json['airtime'],
      runtime: json['runtime'],
      rating: Rating.fromJson(json['rating']),
      image: ImageDetails.fromJson(json['image']),
      summary: json['summary'],
    );
  }
}

class ImageDetails {
  final String medium;

  ImageDetails({required this.medium});

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      medium: json['medium'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medium': medium,
    };
  }
}

class Rating {
  final double? average;

  Rating({this.average});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: json['average']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
    };
  }
}
