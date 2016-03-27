
library wasanbon_xmlrpc.appshare;
import "base.dart";
import 'dart:async';
import 'processes.dart';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;


class AppVersionInfo {
  String version = "";
  String url = "";
  String description =  "";
  AppVersionInfo(this.version, Map map) {
    url = map['url'];
    description = map['description'];
  }
}


class AppInfo {

  String name = "";

  Map<String, AppVersionInfo> versions = {};

  AppVersionInfo get newestVersionInfo {
    List keys = [];
    keys.addAll(versions.keys);
    keys.sort();
    return versions[keys.last];
  }

  AppInfo(this.name, Map result) {
    result.forEach((var key, Map value) {
      versions[key] = new AppVersionInfo(key, value);
    });
  }

  String toString() {
    var s = "- $name\n";
    for(String n in versions.keys) {
      s += "  $n\n";
      s += "    url : ${versions[n].url}\n";
      s += "    description : ${versions[n].description}\n";
    }
    return s;
  }
}

class AppshareFunction extends WasanbonRPCBase {

  AppshareFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }

  /// パッケージ (pkgName) 内のRTCのリストを取得
  Future<List<AppInfo>> list() {
    logger.fine('${this.runtimeType}.list()');
    var completer = new Completer();
    rpc('appshare_list', []).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(null);

      var apps = [];
      for(String name in result[2].keys) {
        apps.add(new AppInfo(name, result[2][name]));
      }
      apps.sort((AppInfo a, AppInfo b) => a.name.compareTo(b.name));
      completer.complete(apps);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<bool> download(String appName, {String version : ''}) {
    logger.fine('${this.runtimeType}.download($appName, $version)');
    var completer = new Completer();
    rpc('appshare_download', [appName, version]).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(false);
      completer.complete(true);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

}