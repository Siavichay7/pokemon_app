import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokemon_app/config/api/pokemon_api.dart';
import 'package:pokemon_app/domain/entities/pokemon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_providers.g.dart';

@Riverpod(keepAlive: true)
class PokemonApiProvider extends _$PokemonApiProvider {
  @override
  List<dynamic> build() => [];

  Future<dynamic> getPokemons(int limit) async {
    final response = await PokemonApi.getPokemons(limit);
    await Future.delayed(const Duration(seconds: 20));
    if (response.length > 0) {
      state = response;
      return state;
    }
  }
}
