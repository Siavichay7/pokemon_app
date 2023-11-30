// import 'dart:developer';

// import 'package:async/async.dart';
// import 'package:flutter/material.dart';
// import 'package:pokemon_app/config/api/pokemon_api.dart';
// import 'package:pokemon_app/domain/entities/pokemon.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'pokemon_providers.g.dart';

// @Riverpod(keepAlive: false)
//   Future<dynamic> getPokemons(int limit) async {
    


//     try {
//       print("CANT DEL STATE: ${state.length}");
//     print(limit + 10);
//     print("CANT DEL LIMIT: ${limit}");
//     final response = await PokemonApi.getPokemons(limit);
//           final isLastPage = response.length < _pageSize;
//     if (isLastPage) {
//         _pagingController.appendLastPage(newItems);
//       } else {
//         final nextPageKey = pageKey + newItems.length;
//         _pagingController.appendPage(newItems, nextPageKey);
//       }
//     await Future.delayed(const Duration(seconds: 10));
//     if (response.length > 0) {
//       ref.onDispose(() {
//         print('Estamos a punto de eliminar este provider');
//       });
//       ref.onCancel(() {
//         print('Estamos a punto de eliminar este provider');
//       });
//       inspect(state);
//       return response;
//     }
      
//     } catch (error) {
//       _pagingController.error = error;
//     }
//   }
