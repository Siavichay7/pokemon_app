import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pokemon_app/domain/entities/pokemon.dart';

class PokemonApi {
  static Future<dynamic> getPokemons(limit) async {
    final dio = Dio();
    int limitCount = limit + 20;
    // await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await dio.get(
          'https://pokeapi.co/api/v2/pokemon?limit=${limitCount}&offset=0');

      List pokemonList = (response.data)['results'];
      // Create a list to store the Pokemon names and images
      var pokemonData = [];

      pokemonList.forEach((pokemon) async {
        var pokemonDetails = await dio.get((pokemon['url']));
        var details = pokemonDetails.data;
        pokemonData.add({
          'name': details['name'],
          'image': details['sprites']['front_default'],
        });
      });
      return pokemonData;
    } catch (e) {
      throw Exception(e);
    }
  }
}
