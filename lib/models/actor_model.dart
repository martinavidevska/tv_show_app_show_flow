
import 'package:group_project/models/tv_show_model.dart';

class Actor {
  final Person person;
  final Character character;

  Actor({
    required this.person,
    required this.character,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      person: Person.fromJson(json['person']),
      character: Character.fromJson(json['character']),
    );
  }
}

class Person {
  final int id;
  final String url;
  final String name;
  final String? birthday;
  final String? deathday; 
  final String? gender;
  final ImageDetails image;
  final Country? country;

  Person({
    required this.id,
    required this.url,
    required this.name,
     this.birthday,
    this.deathday,
     this.gender,
    required this.image,
    this.country
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      birthday: json['birthday'],
      deathday: json['deathday'],
      gender: json['gender'],
      image: ImageDetails.fromJson(json['image']),
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
    );
  }

}

class Character {
  final int id;
  final String name;

  Character({
    required this.id,
    required this.name,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Country{
  final String name;

  Country({required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
    );
  }

}

class ActorCredits{
  final Show showName; 
  final Character character;

  ActorCredits({required this.showName, required this.character});

  

}
