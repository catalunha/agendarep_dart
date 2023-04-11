import 'package:parse_server_sdk/parse_server_sdk.dart';

class DeleteTable {
  deleteByIdInTable({required String objectId, required String table}) async {
    final parseObject = ParseObject(table);
    parseObject.objectId = objectId;
    await parseObject.delete();
  }

  Future<void> removeBySellerInTable(
      {required String sellerId, required String table}) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(table));
    query.whereEqualTo('seller',
        (ParseObject('UserProfile')..objectId = sellerId).toPointer());
    ParseResponse parseResponse = await query.query();

    if (parseResponse.success && parseResponse.results != null) {
      for (ParseObject element in parseResponse.results!) {
        print('Removendo em $table o id: ${element.objectId}');
        await element.delete();
      }
    }
  }
}
