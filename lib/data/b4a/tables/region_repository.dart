import 'package:parse_server_sdk/parse_server_sdk.dart';

class RegionRepository {
  Future<String?> duplicateOne(
      {required String sellerReceiver, required String id}) async {
    final parseObjectDonate = ParseObject('Region');
    ParseResponse parseResponse = await parseObjectDonate.getObject(id);
    if (parseResponse.success && parseResponse.results != null) {
      ParseObject parseObjectDonateResult =
          parseResponse.results!.first as ParseObject;
      print(
          'Region. Duplicando da origem: ${parseObjectDonateResult.objectId}');

      final parseObjectReceiver = ParseObject('Region');
      parseObjectReceiver.set('seller',
          (ParseObject('UserProfile')..objectId = sellerReceiver).toPointer());
      parseObjectReceiver.set('uf', parseObjectDonateResult.get('uf'));
      parseObjectReceiver.set('city', parseObjectDonateResult.get('city'));
      parseObjectReceiver.set('name', parseObjectDonateResult.get('name'));
      parseResponse = await parseObjectReceiver.save();
      if (parseResponse.success && parseResponse.results != null) {
        ParseObject parseObjectReceiverResult =
            parseResponse.results!.first as ParseObject;
        return parseObjectReceiverResult.objectId;
      }
      return null;
    }
    return null;
  }

  Future<void> duplicateAll({required String sellerReceiver}) async {
    final parseObject = ParseObject('Region');
    ParseResponse parseResponse = await parseObject.getAll();

    if (parseResponse.success && parseResponse.results != null) {
      for (ParseObject element in parseResponse.results!) {
        print('Duplicando Region id: ${element.objectId}');
        await duplicateOne(
            sellerReceiver: sellerReceiver, id: element.objectId!);
      }
    }
  }
}
