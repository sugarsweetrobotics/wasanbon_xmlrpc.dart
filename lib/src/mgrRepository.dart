

library wasanbon_xmlrpc.mgrRepository;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;
import 'package:logging/logging.dart';



class MgrRepositoryFunction extends WasanbonRPCBase {

  MgrRepositoryFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  Future<List<RtcRepositoryInfo>> list(pkg) {
    var completer = new Completer();
    print('${this.runtimeType}.list($pkg)');
    rpc('mgrRepository_list', [pkg]).then((result) {
      print(' - $result');
      if (!result[0]) completer.complete(null);

      List<RtcRepositoryInfo> infoList = new List<RtcRepositoryInfo>();
      yaml.YamlMap map = yaml.loadYaml(result[2]);
      map.keys.forEach((key) {
        infoList.add(new RtcRepositoryInfo(key, map[key]));
      });
      infoList.sort((a, b) => a.name.compareTo(b.name));
      completer.complete(infoList);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> clone(pkg, rtc) {
    var completer = new Completer();
    print('${this.runtimeType}.clone($pkg, $rtc)');
    rpc('mgrRepository_clone', [pkg, rtc]).then((result) {
      print(' - $result');
      if (!result[0]) completer.complete(null);

      completer.complete(result[2]);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });

    return completer.future;
  }

}
