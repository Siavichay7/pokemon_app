import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_providers.g.dart';

@Riverpod(keepAlive: true)
class Internet extends _$Internet {
  @override
  bool build() => false;

  Future<dynamic> getConnection() async {
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
  }

  Future<dynamic> restartConnection() async {
    state = true;
  }
}
