
library wasanbon_xmlrpc.system;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;
import 'base.dart';


class SystemFunction extends WasanbonRPCBase {

  SystemFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }

  Future<bool> runDefaultSystem(String packageName) {
    var completer = new Completer();
    rpc('run_default_system', [packageName])
    .then((result) {
      completer.complete(result[1] == 0 ? true : false);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<bool> terminateSystem(String packageName) {
    var completer = new Completer();
    rpc('terminate_system', [packageName])
    .then((result) {
      completer.complete(result[1] == 0 ? true : false);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

}