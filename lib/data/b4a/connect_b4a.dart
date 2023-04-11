import 'dart:developer';
import 'dart:io';

import 'package:parse_server_sdk/parse_server_sdk.dart';

class ConnectB4A {
  final String _appId = 'VtcsOwYidKPYKz4gTXbLELZXEiu0s5xbo4JGu3wJ';
  final String _clientKey = 'glVe7bAt5ve2fbPFUOyridy8goa21Ch9jMA0hR1i';

  getCredentials() {}

  Future<void> initialize() async {
    getCredentials();
    String serverUrl = 'https://parseapi.back4app.com';
    await Parse().initialize(
      _appId,
      serverUrl,
      clientKey: _clientKey,
      debug: false,
      //para usar progressCallback é necessario habilitar clientCreator com DIO
      // clientCreator: (
      //         {bool? sendSessionId, SecurityContext? securityContext}) =>
      //     ParseDioClient(sendSessionId: true, securityContext: securityContext),
    );
    await healthCheck();
  }

  /// No healthCheck se o valor de appId ou clientKey estiver errado
  /// ele gera uma exceção.
  /// Mas ele nao deveria gerar uma exceção. Tinha que retornar um
  /// (await Parse().healthCheck()).success = false
  /// Então relatei isto nesta issue
  /// https://github.com/parse-community/Parse-SDK-Flutter/issues/799
  /// Pra resolver isto envolvi com um try...catch

  Future<void> healthCheck() async {
    // try {
    if ((await Parse().healthCheck()).success) {
      log('Back4app Connected.');
    } else {
      log('Back4app NOT Connected.');
      log('Exit app.');
      exit(0);
    }
    // } catch (e) {
    //   log('Parse().healthCheck() with erros.');
    //   log('Back4app NOT Connected.');
    //   log('Exit app.');
    //   exit(0);
    // }
  }
}
