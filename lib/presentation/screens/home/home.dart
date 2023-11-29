import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/config/api/pokemon_api.dart';
import 'package:pokemon_app/domain/entities/pokemon.dart';
import 'package:pokemon_app/presentation/providers/internet_providers.dart';
import 'package:pokemon_app/presentation/providers/pokemon_providers.dart';
import 'package:pokemon_app/presentation/screens/home/not_internet.dart';
import 'package:pokemon_app/presentation/widgets/skeleton.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  List pokemonsList = [];
  @override
  Widget build(BuildContext context) {
    final hasInternet = ref.watch(internetProvider);
    final pokemonProv = ref.watch(pokemonApiProviderProvider);

    return Scaffold(
      body: !hasInternet
          ? FutureBuilder<dynamic>(
              future: ref
                  .watch(pokemonApiProviderProvider.notifier)
                  .getPokemons(pokemonProv.length),
              builder: (BuildContext? context, AsyncSnapshot? snapshot) {
                if (snapshot!.hasData) {
                  pokemonsList = snapshot.data;
                  return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Pokemon pokemon = Pokemon.fromMap(snapshot.data[index]);
                      if (index == snapshot.data.length - 1) {
                        return Column(
                          children: [
                            Image.asset(
                              "assets/gif/loading.gif",
                              height: 100,
                              width: 100,
                            ),
                            Center(
                              child: Text("Loading..."),
                            )
                          ],
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PokemonContainer(index: index, pokemon: pokemon),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SkeletonView(),
                      );
                    },
                  );
                }
                return Container();
              },
            )
          : NotInternet(),
    );
  }

  @override
  void initState() {
    super.initState();

    // Agregar el listener al initState para que esté activo desde el principio
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Asegurarse de eliminar el listener cuando el widget se elimina
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Verificar si hemos llegado al final de la lista
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(pokemonApiProviderProvider.notifier)
          .getPokemons(pokemonsList.length);
    }
  }
}

class PokemonContainer extends StatelessWidget {
  Pokemon? pokemon;
  int? index;
  PokemonContainer({super.key, this.index, this.pokemon});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return (Container(
      child: PokemonContent(index: index, pokemon: pokemon),
      height: size.height * 0.1,
      width: size.width * 1,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 186, 186, 186).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xffd94256),
      ),
    ));
  }
}

class PokemonContent extends StatelessWidget {
  Pokemon? pokemon;
  int? index;
  PokemonContent({super.key, this.index, this.pokemon});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Transform.rotate(
                // origin: Offset(5, 1),
                angle: 0.7,
                alignment: Alignment.topCenter,
                child: Container(
                    width: size.width * 0.24,
                    height: size.height.toDouble(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.2,
                        image: AssetImage("assets/images/pokeball.png"),
                        fit: BoxFit.cover,
                      ),
                    ))),
          ),
          Row(
            children: [
              Image.network(
                pokemon!.image.toString(),
                width: size.width * 0.2,
                height: size.height.toDouble(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  pokemon!.name.toString().toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Helvetica Neue",
                      fontSize: size.width * 0.05),
                ),
              ),
            ],
          )
        ]),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            "#" + "00${index! + 1}",
            style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontFamily: "Helvetica Neue",
                fontSize: size.width * 0.1),
          ),
        )
      ],
    );
  }
}
