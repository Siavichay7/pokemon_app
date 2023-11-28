import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import 'config/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PokemonApp()));
}

class PokemonApp extends ConsumerWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
        title: 'PokemonApp',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter);
  }
}
