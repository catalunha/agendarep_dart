import '../data/b4a/tables/delete_table.dart';

void deleteTable() {
  DeleteTable deleteTable = DeleteTable();
  deleteTable.removeBySellerInTable(sellerId: 'mwHolsSQ5U', table: 'Region');
  deleteTable.removeBySellerInTable(sellerId: 'mwHolsSQ5U', table: 'Address');
}
