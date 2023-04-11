import 'data/b4a/connect_b4a.dart';
import 'feature/delete.dart';
import 'feature/schedule.dart';

void app() async {
  ConnectB4A connectB4A = ConnectB4A();
  await connectB4A.initialize();

  await deleteTable();
  // region();
  // address();
  // medical();
  // secretary();
  // clinic();
  schedule();
}
