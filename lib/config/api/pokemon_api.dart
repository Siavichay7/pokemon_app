import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pokemon_app/domain/entities/pokemon.dart';

class PokemonApi {
  static Future<dynamic> getPokemons(offset, limit) async {
    final dio = Dio();
    try {
      final response = await dio.get(
          'https://pokeapi.co/api/v2/pokemon?limit=${limit}&offset=${offset}');

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
      await Future.delayed(const Duration(seconds: 10));
      return pokemonData;
    } catch (e) {
      throw Exception(e);
    }
  }
}
