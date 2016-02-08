

library wasanbon_xmlrpc.setting;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;




class SettingFunction extends WasanbonRPCBase {

  SettingFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }

  /// Echo function for test
  Future<String> echo(String code) {
    logger.fine('${this.runtimeType}.echo($code)');
    var completer = new Completer();
    rpc('setting_echo', [code]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  ///
  Future<List<String>> readyPackages() {
    logger.fine('${this.runtimeType}.readyPackages()');
    var completer = new Completer();
    rpc('setting_ready_packages', []).then((result) {
      logger.finer(' - $result');

      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


  ///
  Future<bool> uploadPackage(String filename, String content) {
    logger.fine('${this.runtimeType}.uploadPackage($filename, $content)');
    var completer = new Completer();
    rpc('setting_upload_package', [filename, content]).then((result) {
      logger.finer(' - $result');

      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  ///
  Future<bool> removePackage(String filename) {
    logger.fine('${this.runtimeType}.removePackage($filename)');
    var completer = new Completer();
    rpc('setting_remove_package', [filename]).then((result) {
      logger.finer(' - $result');

      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


}