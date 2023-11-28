import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/presentation/screens/home/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    )
  ]);
}
