import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'clinic_repository.dart';

class ScheduleRepository {
  Future<String?> duplicateOne(
      {required String sellerIdReceiver, required String id}) async {
    final parseObjectDonate = ParseObject('Schedule');
    ParseResponse parseResponse = await parseObjectDonate.getObject(id);
    if (parseResponse.success && parseResponse.results != null) {
      ParseObject parseObjectDonateResult =
          parseResponse.results!.first as ParseObject;
      print(
          'Schedule. Duplicando da origem: ${parseObjectDonateResult.objectId}');

      final parseObjectReceiver = ParseObject('Schedule');
      parseObjectReceiver.set(
          'seller',
          (ParseObject('UserProfile')..objectId = sellerIdReceiver)
              .toPointer());
      parseObjectReceiver.set(
          'expertise', parseObjectDonateResult.get('expertise'));
      parseObjectReceiver.set(
          'mondayHours', parseObjectDonateResult.get('mondayHours'));
      parseObjectReceiver.set(
          'tuesdayHours', parseObjectDonateResult.get('tuesdayHours'));
      parseObjectReceiver.set(
          'wednesdayHours', parseObjectDonateResult.get('wednesdayHours'));
      parseObjectReceiver.set(
          'thursdayHours', parseObjectDonateResult.get('thursdayHours'));
      parseObjectReceiver.set(
          'fridayHours', parseObjectDonateResult.get('fridayHours'));
      parseObjectReceiver.set(
          'saturdayHours', parseObjectDonateResult.get('saturdayHours'));
      parseObjectReceiver.set(
          'sundayHours', parseObjectDonateResult.get('sundayHours'));
      parseObjectReceiver.set(
          'justScheduled', parseObjectDonateResult.get('justScheduled'));
      parseObjectReceiver.set(
          'limitedSellers', parseObjectDonateResult.get('limitedSellers'));
      parseObjectReceiver.set(
          'description', parseObjectDonateResult.get('description'));
      parseObjectReceiver.set(
          'isDeleted', parseObjectDonateResult.get('isDeleted'));

      if (parseObjectDonateResult.get('clinic') != null) {
        ParseObject parseObject = parseObjectDonateResult.get('clinic');
        ClinicRepository clinicRepository = ClinicRepository();

        ParseObject? clinicParseObject = await clinicRepository.duplicateOne(
          id: parseObject.objectId!,
          sellerIdReceiver: sellerIdReceiver,
        );
        if (clinicParseObject != null) {
          parseObjectReceiver.set(
              'clinic',
              (ParseObject('Clinic')..objectId = clinicParseObject.objectId)
                  .toPointer());
          if (clinicParseObject.get('medical') != null) {
            ParseObject parseObject = clinicParseObject.get('medical');
            parseObjectReceiver.set(
                'medical',
                (ParseObject('Medical')..objectId = parseObject.objectId)
                    .toPointer());
          } else {
            print('>>> Nao há medical a ser duplicado');
          }
        }
      } else {
        print('>>> Nao há clinic a ser duplicada');
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

  Future<void> duplicateAll(
      {required String sellerIdReceiver,
      required String sellerIdDonate}) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Schedule'));
    query.whereEqualTo('seller',
        (ParseObject('UserProfile')..objectId = sellerIdDonate).toPointer());
    ParseResponse parseResponse = await query.query();

    if (parseResponse.success && parseResponse.results != null) {
      for (ParseObject element in parseResponse.results!) {
        print('Duplicando Schedule id: ${element.objectId}');
        await duplicateOne(
            sellerIdReceiver: sellerIdReceiver, id: element.objectId!);
      }
    }
  }
}
