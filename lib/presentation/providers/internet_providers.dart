import 'package:flutter/material.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:pokemon_app/presentation/screens/home/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_providers.g.dart';

@Riverpod(keepAlive: true)
Stream<bool?> getConnection(GetConnectionRef ref) async* {
  bool? data;
  final subscription = InternetConnectivity()
      .observeInternetConnection
      .listen((bool hasInternetAccess) {
    if (!hasInternetAccess) {
      data = false;
      print("STATE: $data");
    } else {
      data = true;
      print("STATE: $data");
    }
  });

  await Future.delayed(const Duration(seconds: 10));
  yield data;

  // subscription.cancel();
}
