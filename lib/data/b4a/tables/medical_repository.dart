import 'package:parse_server_sdk/parse_server_sdk.dart';

class MedicalRepository {
  Future<String?> duplicateOne(
      {required String sellerReceiver, required String id}) async {
    final parseObjectDonate = ParseObject('Medical');
    ParseResponse parseResponse = await parseObjectDonate.getObject(id);
    if (parseResponse.success && parseResponse.results != null) {
      ParseObject parseObjectDonateResult =
          parseResponse.results!.first as ParseObject;
      print(
          'Medical. Duplicando da origem: ${parseObjectDonateResult.objectId}');

      final parseObjectReceiver = ParseObject('Medical');
      parseObjectReceiver.set('seller',
          (ParseObject('UserProfile')..objectId = sellerReceiver).toPointer());
      parseObjectReceiver.set('email', parseObjectDonateResult.get('email'));
      parseObjectReceiver.set('name', parseObjectDonateResult.get('name'));
      parseObjectReceiver.set('phone', parseObjectDonateResult.get('phone'));
      parseObjectReceiver.set('crm', parseObjectDonateResult.get('crm'));
      parseObjectReceiver.set(
          'isBlocked', parseObjectDonateResult.get('isBlocked'));
      parseObjectReceiver.set(
          'birthday', parseObjectDonateResult.get('birthday'));
      parseObjectReceiver.set(
          'isDeleted', parseObjectDonateResult.get('isDeleted'));
      parseObjectReceiver.set(
          'expertises', parseObjectDonateResult.get('expertises'));
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
    final parseObject = ParseObject('Medical');
    ParseResponse parseResponse = await parseObject.getAll();

    if (parseResponse.success && parseResponse.results != null) {
      for (ParseObject element in parseResponse.results!) {
        print('Duplicando Medical id: ${element.objectId}');
        await duplicateOne(
            sellerReceiver: sellerReceiver, id: element.objectId!);
      }
    }
  }
}
