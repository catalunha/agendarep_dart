import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'address_repository.dart';
import 'medical_repository.dart';
import 'secretary_repository.dart';

class ClinicRepository {
  Future<ParseObject?> duplicateOne(
      {required String sellerIdReceiver, required String id}) async {
    final parseObjectDonate = ParseObject('Clinic');
    ParseResponse parseResponse = await parseObjectDonate.getObject(id);
    if (parseResponse.success && parseResponse.results != null) {
      ParseObject parseObjectDonateResult =
          parseResponse.results!.first as ParseObject;
      print(
          'Clinic. Duplicando da origem: ${parseObjectDonateResult.objectId}');

      final parseObjectReceiver = ParseObject('Clinic');
      parseObjectReceiver.set(
          'seller',
          (ParseObject('UserProfile')..objectId = sellerIdReceiver)
              .toPointer());
      parseObjectReceiver.set('name', parseObjectDonateResult.get('name'));
      parseObjectReceiver.set('phone', parseObjectDonateResult.get('phone'));
      parseObjectReceiver.set('room', parseObjectDonateResult.get('room'));
      parseObjectReceiver.set(
          'isDeleted', parseObjectDonateResult.get('isDeleted'));

      if (parseObjectDonateResult.get('medical') != null) {
        ParseObject parseObject = parseObjectDonateResult.get('medical');
        MedicalRepository medicalRepository = MedicalRepository();

        String? medicalId = await medicalRepository.duplicateOne(
          id: parseObject.objectId!,
          sellerIdReceiver: sellerIdReceiver,
        );
        if (medicalId != null) {
          parseObjectReceiver.set('medical',
              (ParseObject('Medical')..objectId = medicalId).toPointer());
        }
      } else {
        print('>>> Nao há medical a ser duplicada');
      }

      if (parseObjectDonateResult.get('address') != null) {
        ParseObject parseObject = parseObjectDonateResult.get('address');
        AddressRepository addressRepository = AddressRepository();

        String? addressId = await addressRepository.duplicateOne(
          id: parseObject.objectId!,
          sellerIdReceiver: sellerIdReceiver,
        );
        if (addressId != null) {
          parseObjectReceiver.set('address',
              (ParseObject('Address')..objectId = addressId).toPointer());
        }
      } else {
        print('>>> Nao há address a ser duplicado');
      }

      //+++ get secretary
      List<String> secretaryIds = [];

      QueryBuilder<ParseObject> querySecretary =
          QueryBuilder<ParseObject>(ParseObject('Secretary'));
      querySecretary.whereRelatedTo(
          'secretaries', 'Clinic', parseObjectDonateResult.objectId!);
      final ParseResponse parseResponseSecretary = await querySecretary.query();
      if (parseResponseSecretary.success &&
          parseResponseSecretary.results != null) {
        for (ParseObject e in parseResponseSecretary.results!) {
          SecretaryRepository secretaryRepository = SecretaryRepository();
          String? newId = await secretaryRepository.duplicateOne(
              sellerIdReceiver: sellerIdReceiver, id: e.objectId!);
          if (newId != null) {
            secretaryIds.add(newId);
          }
        }
      }
      //--- get secretary

      parseResponse = await parseObjectReceiver.save();
      if (parseResponse.success && parseResponse.results != null) {
        ParseObject parseObjectReceiverResult =
            parseResponse.results!.first as ParseObject;
        await updateRelationSecretaries(
          objectId: parseObjectReceiverResult.objectId!,
          ids: secretaryIds,
          add: true,
        );
        return parseObjectReceiverResult;
      }
      return null;
    }
    return null;
  }

  Future<void> duplicateAll(
      {required String sellerIdReceiver,
      required String sellerIdDonate}) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Clinic'));
    query.whereEqualTo('seller',
        (ParseObject('UserProfile')..objectId = sellerIdDonate).toPointer());
    ParseResponse parseResponse = await query.query();

    if (parseResponse.success && parseResponse.results != null) {
      for (ParseObject element in parseResponse.results!) {
        print('Duplicanto Clinic id: ${element.objectId}');
        await duplicateOne(
            sellerIdReceiver: sellerIdReceiver, id: element.objectId!);
      }
    }
  }

  Future<void> updateRelationSecretaries(
      {required String objectId,
      required List<String> ids,
      required bool add}) async {
    final parseObject =
        _toParseRelationSecretaries(objectId: objectId, ids: ids, add: add);
    if (parseObject != null) {
      await parseObject.save();
    }
  }

  ParseObject? _toParseRelationSecretaries({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject('Clinic');
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset('secretaries');
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        'secretaries',
        ids
            .map(
              (element) => ParseObject('Secretary')..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          'secretaries',
          ids
              .map((element) => ParseObject('Secretary')..objectId = element)
              .toList());
    }
    return parseObject;
  }
}
