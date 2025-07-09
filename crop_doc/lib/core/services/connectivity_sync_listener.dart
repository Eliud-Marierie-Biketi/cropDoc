import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crop_doc/core/database/app_database.dart';

void listenForConnectivity(AppDatabase db) {
  Connectivity().onConnectivityChanged.listen((
    List<ConnectivityResult> results,
  ) async {
    if (results.any((result) => result != ConnectivityResult.none)) {
      final hasInternet = await isConnectedToInternet();
      if (hasInternet) {
        await trySyncWithBackend(db);
      }
    }
  });
}
