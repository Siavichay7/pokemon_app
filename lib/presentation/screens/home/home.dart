import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/config/api/pokemon_api.dart';
import 'package:pokemon_app/domain/entities/pokemon.dart';
import 'package:pokemon_app/presentation/providers/pokemon_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemons = ref.watch(getPokemonsProvider);
    return Scaffold(
        body: pokemons.when(
      data: (pokemons) => ListView.builder(
        shrinkWrap: true,
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          Pokemon pokemon = Pokemon.fromMap(pokemons[index]);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PokemonContainer(index: index, pokemon: pokemon),
          );
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('$error'),
    ));
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
              Text(
                pokemon!.name.toString().toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Helvetica Neue",
                    fontSize: size.width * 0.05),
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
                fontSize: size.width * 0.08),
          ),
        )
      ],
    );
  }
}
