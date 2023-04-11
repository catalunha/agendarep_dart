import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'region_repository.dart';

class AddressRepository {
  Future<String?> duplicateOne(
      {required String sellerReceiver, required String id}) async {
    final parseObjectDonate = ParseObject('Address');
    ParseResponse parseResponse = await parseObjectDonate.getObject(id);
    if (parseResponse.success && parseResponse.results != null) {
      ParseObject parseObjectDonateResult =
          parseResponse.results!.first as ParseObject;
      print(
          'Address. Duplicando da origem: ${parseObjectDonateResult.objectId}');

      final parseObjectReceiver = ParseObject('Address');
      parseObjectReceiver.set('seller',
          (ParseObject('UserProfile')..objectId = sellerReceiver).toPointer());
      parseObjectReceiver.set('name', parseObjectDonateResult.get('name'));
      parseObjectReceiver.set('phone', parseObjectDonateResult.get('phone'));
      parseObjectReceiver.set(
          'description', parseObjectDonateResult.get('description'));
      parseObjectReceiver.set(
          'parseGeoPoint', parseObjectDonateResult.get('parseGeoPoint'));
      parseObjectReceiver.set(
          'isDeleted', parseObjectDonateResult.get('isDeleted'));

      if (parseObjectDonateResult.get('region') != null) {
        ParseObject parseObject = parseObjectDonateResult.get('region');
        RegionRepository regionRepository = RegionRepository();

        String? regionId = await regionRepository.duplicateOne(
          id: parseObject.objectId!,
          sellerReceiver: sellerReceiver,
        );
        if (regionId != null) {
          parseObjectReceiver.set('region',
              (ParseObject('Region')..objectId = regionId).toPointer());
        }
      } else {
        print('>>> Nao há Region a ser duplicada');
      }

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
    final parseObject = ParseObject('Address');
    ParseResponse parseResponse = await parseObject.getAll();

    if (parseResponse.success && parseResponse.results != null) {
      for (ParseObject element in parseResponse.results!) {
        print('Duplicanto Address id: ${element.objectId}');
        await duplicateOne(
            sellerReceiver: sellerReceiver, id: element.objectId!);
      }
    }
  }
}
