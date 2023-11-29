import 'package:pokemon_app/config/api/pokemon_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_providers.g.dart';

@Riverpod(keepAlive: true)
Future<dynamic> getPokemons(GetPokemonsRef ref) async {
  final response = await PokemonApi.getPokemons();
  return response;
}
