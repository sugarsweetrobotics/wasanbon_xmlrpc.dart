

library wasanbon_xmlrpc.rtc;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;



class BuildInfo {
  bool success = false;
  String stdout = "";
  BuildInfo(this.success, this.stdout) {}

  String toString() {
    return stdout;
  }
}

class RtcFunction extends WasanbonRPCBase {

  RtcFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }

  Future<BuildInfo> buildRTC(String packageName, String rtcName) {
    var completer = new Completer();
    rpc('build_rtc', [packageName, rtcName])
    .then((result) {
      completer.complete(new BuildInfo(result[1] == 0, result[2]));
    })
    .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<BuildInfo> cleanRTC(String packageName, String rtcName) {
    var completer = new Completer();
    rpc('clean_rtc', [packageName, rtcName])
    .then((result) {
      completer.complete(new BuildInfo(result[1] == 0, result[2]));
    })
    .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<BuildInfo> deleteRTC(String packageName, String rtcName) {
    var completer = new Completer();
    rpc('delete_rtc', [packageName, rtcName])
    .then((result) {
      completer.complete(new BuildInfo(result[1] == 0, result[2]));
    })
    .catchError((error) => completer.completeError(error));
    return completer.future;
  }
}