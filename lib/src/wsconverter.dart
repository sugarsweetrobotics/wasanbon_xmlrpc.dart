

library wasanbon_xmlrpc.wsconverter;
import "base.dart";
import 'dart:async';
import 'processes.dart';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;




class WSConverterFunction extends WasanbonRPCBase {

  WSConverterFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }


  Future<Process> start(int port) {
    var completer = new Completer();
    logger.fine('${this.runtimeType}.start($port)');
    rpc('wsconverter_start', [port]).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(null);

      if (result[0]) completer.complete(new Process(result[2][0], result[2][1]));
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<bool> stop() {
    var completer = new Completer();
    logger.fine('${this.runtimeType}.stop()');
    rpc('wsconverter_stop', []).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(null);

      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

}