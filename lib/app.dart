import 'package:agendarep_dart/feature/delete.dart';

import 'data/b4a/connect_b4a.dart';

void app() async {
  ConnectB4A connectB4A = ConnectB4A();
  await connectB4A.initialize();

  deleteTable('Region');
  // authorPage();
  // shapePage();
  // publisherPage();
  // bookPage();
}
