import 'dart:developer';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/config/api/pokemon_api.dart';
import 'package:pokemon_app/domain/entities/pokemon.dart';
import 'package:pokemon_app/presentation/providers/internet_providers.dart';
import 'package:pokemon_app/presentation/providers/pokemon_providers.dart';
import 'package:pokemon_app/presentation/screens/home/not_internet.dart';
import 'package:pokemon_app/presentation/widgets/skeleton.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  List pokemonsList = [];
  static const _pageSize = 10;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  Widget build(BuildContext context) {
    final hasInternetProvider = ref.watch(getConnectionProvider);

    if (hasInternetProvider.isLoading) {
      return Scaffold(
          body: ListView.builder(
        shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SkeletonView(),
          );
        },
      ));
    }

    final hasInternet = hasInternetProvider.value;

    // print("CANT: ${pokemonProv.length}");
    return Scaffold(
        body: !!hasInternet!
            ? PagedListView<int, dynamic>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  itemBuilder: (context, item, index) {
                    print("ITEM: ${item}");
                    if (item != null) {
                      Pokemon pokemon = Pokemon.fromMap(item);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PokemonContainer(index: index, pokemon: pokemon),
                      );
                    } else {
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
                  },
                  firstPageErrorIndicatorBuilder: (_) => NotInternet(),
                  newPageErrorIndicatorBuilder: (_) => NotInternet(),
                  firstPageProgressIndicatorBuilder: (_) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SkeletonView(),
                  ),
                  newPageProgressIndicatorBuilder: (_) => Column(
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
                  ),

                  // noItemsFoundIndicatorBuilder: (_) => NoItemsFoundIndicator(),
                  // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
                ),
              )
            : NotInternet());
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await await PokemonApi.getPokemons(pageKey, _pageSize);
      inspect(newItems);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(
            newItems, int.parse(nextPageKey.toString()));
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
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
