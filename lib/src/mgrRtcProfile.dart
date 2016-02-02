

library wasanbon_xmlrpc.package;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;



class MgrRtcProfileFunction extends WasanbonRPCBase {

  MgrRtcProfileFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  /// パッケージ (PackageName) 内のRTC (rtcName) のRTCプロファイルをXmlDocument (xml) 形式で取得
  Future<xml.XmlDocument> getRTCProfile(String packageName, String rtcName) {
    var completer = new Completer();
    rpc('rtc_profile', [packageName, rtcName]).then((result) {
      xml.XmlDocument elem = xml.parse(result[1].toString());
      completer.complete(elem);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }


  Future<String> saveRTCProfile(String packageName, String rtcName, String content) {
    var completer = new Completer();
    rpc('rtcprofile_update', [packageName, rtcName, content])
        .then((result) {
      completer.complete(result[1]);
    })
        .catchError((error) => completer.completeError(error));

    return completer.future;
  }

}