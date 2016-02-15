
library wasanbon_xmlrpc.system;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;
import 'base.dart';


class MgrSystemFunction extends WasanbonRPCBase {

  MgrSystemFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }

  Future<bool> run(String packageName, String systemName, {bool buildSystem: true, bool activateSystem: true}) {
    logger.fine('${this.runtimeType}.run($packageName, $systemName, $buildSystem, $activateSystem)');
    var completer = new Completer();
    rpc('mgrSystem_run', [packageName, systemName, buildSystem, activateSystem]).then((result) {
      logger.finer(' - $result');
      completer.complete(result[2]);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    } );
    return completer.future;
  }

  Future<bool> terminate(String packageName) {
    logger.fine('${this.runtimeType}.terminate($packageName)');
    var completer = new Completer();
    rpc('mgrSystem_terminate', [packageName]).then((result) {
      logger.finer(' - $result');
      completer.complete(result[2]);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<bool> is_running(String packageName) {
    logger.fine('${this.runtimeType}.is_running($packageName)');
    var completer = new Completer();
    rpc('mgrSystem_is_running', [packageName]).then((result) {
      logger.finer(' - $result');
      completer.complete(result[2]);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

}