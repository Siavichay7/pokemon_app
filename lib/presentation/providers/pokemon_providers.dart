import 'dart:developer';

import 'package:pokemon_app/config/api/pokemon_api.dart';
import 'package:pokemon_app/domain/entities/pokemon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_providers.g.dart';

@Riverpod(keepAlive: true)
Future<dynamic> getPokemons(GetPokemonsRef ref) async {
  final response = await PokemonApi.getPokemons();
  await Future.delayed(const Duration(seconds: 20));
  inspect(response);
  print(response.length);
  if (response.length > 0 && response.length <= 20) {
    return response;
  }
}
