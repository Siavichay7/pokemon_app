// To parse this JSON data, do
//
//     final pokemon = pokemonFromMap(jsonString);

import 'dart:convert';

Pokemon pokemonFromMap(String str) => Pokemon.fromMap(json.decode(str));

String pokemonToMap(Pokemon data) => json.encode(data.toMap());

class Pokemon {
  String? name;
  String? image;

  Pokemon({
    this.name,
    this.image,
  });

  Pokemon copyWith({
    String? name,
    String? image,
  }) =>
      Pokemon(
        name: name ?? this.name,
        image: image ?? this.image,
      );

  factory Pokemon.fromMap(Map<String, dynamic> json) => Pokemon(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "image": image,
      };
}
