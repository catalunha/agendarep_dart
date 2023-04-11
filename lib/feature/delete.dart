import '../data/b4a/delete_table.dart';

void deleteTable(String table) {
  DeleteTable deleteTable = DeleteTable();
  deleteTable.removeBySellerInTable(sellerId: 'mwHolsSQ5U', table: 'Region');
}
