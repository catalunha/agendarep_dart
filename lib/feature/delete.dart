import '../data/b4a/tables/delete_table.dart';

Future<void> deleteTable() async {
  DeleteTable deleteTable = DeleteTable();
  await deleteTable.removeBySellerInTable(
      sellerId: 'mwHolsSQ5U', table: 'Region');
  await deleteTable.removeBySellerInTable(
      sellerId: 'mwHolsSQ5U', table: 'Address');
  await deleteTable.removeBySellerInTable(
      sellerId: 'mwHolsSQ5U', table: 'Secretary');
  await deleteTable.removeBySellerInTable(
      sellerId: 'mwHolsSQ5U', table: 'Medical');
  await deleteTable.removeBySellerInTable(
      sellerId: 'mwHolsSQ5U', table: 'Clinic');
  await deleteTable.removeBySellerInTable(
      sellerId: 'mwHolsSQ5U', table: 'Schedule');
}
