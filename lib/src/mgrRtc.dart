

library wasanbon_xmlrpc.mgrRtc;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;

import 'package:logging/logging.dart';


class RtcInfo {
  String name = "";
  var basicInfo ="";
  var dataports ="";
  var serviceports = "";
  var language = "";
  RtcInfo(this.name, yaml.YamlMap result) {
    this.basicInfo = result['basicInfo'];
    this.dataports = result.keys.contains('dataports') ? result['dataports'] : {};
    this.serviceports = result.keys.contains('serviceports') ? result['serviceports'] : {};
    this.language = result['language']['kind'];
  }

  String toString() {
    return name;
  }
}


class BuildInfo {
  bool success = false;
  String stdout = "";
  BuildInfo(this.success, this.stdout) {}

  String toString() {
    return stdout;
  }
}


class MgrRtcFunction extends WasanbonRPCBase {

  MgrRtcFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }


  /// パッケージ (pkgName) 内のRTCのリストを取得
  Future<List<RtcInfo>> getRtcList(String packageName) {
    logger.fine('${this.runtimeType}.getRtcList($packageName)');
    var completer = new Completer();
    rpc('mgrRtc_list', [packageName]).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(null);

      yaml.YamlMap res = yaml.loadYaml(result[2]);
      var rtcs = [];
      for(String name in res.keys) {
        rtcs.add(new RtcInfo(name, res[name]));
      }
      rtcs.sort((RtcInfo a, RtcInfo b) => a.name.compareTo(b.name));
      completer.complete(rtcs);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  /// RTCのビルド
  Future<BuildInfo> buildRTC(String packageName, String rtcName) {
    logger.fine('${this.runtimeType}.build($packageName, $rtcName)');
    var completer = new Completer();
    rpc('mgrRtc_build', [packageName, rtcName]).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(null);

      completer.complete(new BuildInfo(result[2][0] == 0, result[2][1]));
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  /// RTCのクリーン
  Future<BuildInfo> cleanRTC(String packageName, String rtcName) {
    logger.fine('${this.runtimeType}.clean($packageName, $rtcName)');
    var completer = new Completer();
    rpc('mgrRtc_clean', [packageName, rtcName]).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(null);

      completer.complete(new BuildInfo(result[2][0] == 0, result[2][1]));
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  /// RTCの削除
  Future<String> deleteRTC(String packageName, String rtcName) {
    logger.fine('${this.runtimeType}.delete($packageName, $rtcName)');
    var completer = new Completer();
    rpc('mgrRtc_delete', [packageName, rtcName]).then((result) {
      logger.finer(' - $result');
      if (!result[0]) completer.complete(null);
      completer.complete(result[2]);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }



  Future<List<SystemInfo>> getSystemInfos(String packageName) {
    var completer = new Completer();
    rpc('system_list', [packageName])
    .then((result) {
      yaml.YamlMap res = yaml.loadYaml(result[1]);
      var syss = [];
      for(String name in res.keys) {
        syss.add(new SystemInfo(name, res[name]));
      }
      syss.sort((SystemInfo a, SystemInfo b) => a.name.compareTo(b.name));
      completer.complete(syss);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<List<RTCConfInfo>> getRTCConfList(String packageName) {
    var completer = new Completer();
    rpc('rtcconf_list', [packageName])
    .then((result) {

      var map = yaml.loadYaml(result[1]);
      var infoMap = new List<RTCConfInfo>();
      for(String lang in map.keys) {
        infoMap.add(new RTCConfInfo(lang, map[lang]['path'], map[lang]['value']));
      }
      completer.complete(infoMap);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<xml.XmlDocument> getRTSProfile(String packageName, String rtsName) {
    var completer = new Completer();
    rpc('rts_profile', [packageName, rtsName])
    .then((result) {
      xml.XmlDocument elem = xml.parse(result[1].toString());//XmlElement(result[1]);
      completer.complete(elem);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<String> saveRTSProfile(String packageName, String rtsName, String content) {
    var completer = new Completer();
    rpc('system_update', [packageName, rtsName, content])
    .then((result) {
      completer.complete(result[1]);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }



  Future<String> updateRTCProfile(String packageName, String rtcName) {
    var completer = new Completer();
    rpc('rtcprofile_sync', [packageName, rtcName])
    .then((result) {
      completer.complete(result[1]);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<String> copyRTSProfile(String packageName, String rtsName, String dstName) {
    var completer = new Completer();
    rpc('system_copy', [packageName, rtsName, dstName])
    .then((result) {
      completer.complete(result[1]);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<String> deleteRTSProfile(String packageName, String rtsName) {
    var completer = new Completer();
    rpc('system_delete', [packageName, rtsName])
    .then((result) {
      completer.complete(result[1]);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }



  Future<List<RtcRepositoryInfo>> listRtcRepositories(pkg) {
    var completer = new Completer();
    rpc('rtc_repositories', [pkg])
    .then((result) {
      List<RtcRepositoryInfo> infoList = new List<RtcRepositoryInfo>();
      yaml.YamlMap map = yaml.loadYaml(result[1]);
      map.keys.forEach((key) {
        infoList.add(new RtcRepositoryInfo(key, map[key]));
      });
      infoList.sort((a, b) => a.name.compareTo(b.name));
      completer.complete(infoList);
    })
    .catchError((error) =>
    completer.completeError(error)
    );

    return completer.future;
  }

  Future<String> pullRtcRepository(pkg, rtc) {
    var completer = new Completer();
    rpc('rtc_repository_pull', [pkg, rtc])
    .then((result) {
      completer.complete(result[1]);
    })
    .catchError((error) =>
    completer.completeError(error)
    );

    return completer.future;
  }

  Future<String> pushRtcRepository(pkg, rtc) {
    var completer = new Completer();
    rpc('rtc_repository_push', [pkg, rtc])
    .then((result) {
      completer.complete(result[1]);
    })
    .catchError((error) =>
    completer.completeError(error)
    );

    return completer.future;
  }

  Future<String> commitRtcRepository(pkg, rtc, comment) {
    var completer = new Completer();
    rpc('rtc_repository_commit', [pkg, rtc, comment])
    .then((result) {
      completer.complete(result[1]);
    })
    .catchError((error) =>
    completer.completeError(error)
    );

    return completer.future;
  }
}
