import 'data/b4a/connect_b4a.dart';
import 'feature/address.dart';

void app() async {
  ConnectB4A connectB4A = ConnectB4A();
  await connectB4A.initialize();

  // deleteTable();
  // region();
  address();
  // publisherPage();
  // bookPage();
}
