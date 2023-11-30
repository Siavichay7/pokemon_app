import 'package:flutter/material.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:pokemon_app/presentation/screens/home/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_providers.g.dart';

@Riverpod(keepAlive: true)
class Internet extends _$Internet {
  @override
  bool build() => false;

  Future<bool> getConnection() async {
    final subscription = InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
      if (!hasInternetAccess) {
        state = false;
        print("STATE: $state");
      } else {
        state = true;
        print("STATE: $state");
      }
    });

    await Future.delayed(const Duration(seconds: 10));
    subscription.cancel();
    return state;
  }

  Future<dynamic> restartConnection(context) async {
    state = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    print(state);
  }
}
