// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library wasanbon_xmlrpc.base;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;

class VersionInfo {
  var version = "0.0";
  var platform = "none";
  VersionInfo(result) {
    this.version = result[1]['wasanbon'];
    this.platform = result[1]['platform'];
  }
}


class PackageInfoPack {
  
  
}

class RTCConfInfo {
  String language = "";
  String path = "";
  yaml.YamlMap value;
  
  RTCConfInfo(this.language, this.path, this.value) {}
  
}

class BuildInfo {
  bool success = false;
  String stdout = "";
  BuildInfo(this.success, this.stdout) {}
}

class PackageInfo {
  String name = "";
  String path ="";
  String rtc_dir = "";
  String bin_dir = "";
  String conf_dir = "";
  String system_dir = "";
  String description = "";
  List<String> nameservers = new List<String>();
  String conf_cpp = "";
  String conf_python = "";
  String conf_java = "";
  String defaultSystem = "";
  
  List<String> rtcNames = new List<String>();
  PackageInfo(String this.name, yaml.YamlMap result) {
    this.path = result['path']['root'];
    this.rtc_dir = result['path']['rtc'];
    this.system_dir = result['path']['system'];
    this.conf_dir = result['path']['conf'];
    this.bin_dir = result['path']['bin'];
    if(result['rtcs'] is Iterable) {
      result['rtcs'] as Iterable ..forEach((e) {
        rtcNames.add(e as String);
      });
    } else {
    }
    
    if(result['nameserverss'] is Iterable) {
         result['nameservers'] as Iterable ..forEach((e) {
           nameservers.add(e as String);
         });
       } else {
       }
    
    this.conf_cpp = result['conf']['C++'];
    this.conf_python = result['conf']['Python'];
    this.conf_java = result['conf']['Java'];
    this.defaultSystem = result['defaultSystem'];
  }
}

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
}


class SystemInfo {
  String name = "";
  String id = "";
  String abstract = "";
  bool isDefault = false;
  var components = {};
  SystemInfo(this.name, yaml.YamlMap result) {
      this.id = result['id'];
      this.abstract = result['abstract'];
      this.isDefault = result['default'];// == 'True' ? true : false;
      this.components = result.keys.contains('components') ? result['components'] : {};
  }
}

class WasanbonRPC {
  String url = "RPC";
  http.Client client = null;
  WasanbonRPC({String url:'http://localhost:8000/RPC', http.Client client:null}) {
  //WasanbonRPC({String url:'RPC', http.Client client:null}) {
        this.url = url;
    this.client = client;
  }
  
  Future<dynamic> rpc(String signature, var argument) {
    return xmlrpc.call(url, signature, argument, client: client,
        headers: {'Access-Control-Allow-Origin' : 'http://localhost',
            'Access-Control-Allow-Methods' : 'GET, POST',
            'Access-Control-Allow-Headers' : 'x-prototype-version,x-requested-with'});
  }
  
  /// Get Version Infomation of wasanbon server
  Future<VersionInfo> getVersionInfo() {
    var completer = new Completer();
    rpc('version', [])
      .then((result) => completer.complete(new VersionInfo(result)))
      .catchError((error) => completer.completeError(error));
    return completer.future;
  }
  
  /// Get Package Info List of wasanbon server
  Future<List<PackageInfo>> getPackageInfos() {
    var completer = new Completer();
    rpc('packages', [])
    .then((result) {
      yaml.YamlMap res = yaml.loadYaml(result[1]);
      List<PackageInfo> pkgs = [];
      for(String name in res.keys) {
        pkgs.add(new PackageInfo(name, res[name]));
      }
      pkgs.sort((a, b) => a.name.compareTo(b.name));
      completer.complete(pkgs);
    })
    .catchError((error) => completer.completeError(error));
    
    return completer.future;
  }
  
  /// 
  Future<List<RtcInfo>> getRtcInfos(String packageName) {
    var completer = new Completer();
    rpc('rtc_list', [packageName])
    .then((result) { 
      yaml.YamlMap res = yaml.loadYaml(result[1]);
      var rtcs = [];
      for(String name in res.keys) {
        rtcs.add(new RtcInfo(name, res[name]));
      }
      completer.complete(rtcs);
    })
    .catchError((error) => completer.completeError(error));
    
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
      completer.complete(syss);
    })
    .catchError((error) => completer.completeError(error));
    
    return completer.future;
  }
  
  Future<xml.XmlDocument> getRTCProfile(String packageName, String rtcName) {
    var completer = new Completer();
    rpc('rtc_profile', [packageName, rtcName])
    .then((result) { 
      xml.XmlDocument elem = xml.parse(result[1].toString());//XmlElement(result[1]);
      completer.complete(elem);
    })
    .catchError((error) => completer.completeError(error));
    
    return completer.future;
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
  
  Future<String> startNameService(int port) {
    var completer = new Completer();
    rpc('start_name_service', [port])
    .then((result) { 
      completer.complete(result[1].toString());
    })
    .catchError((error) => completer.completeError(error));
    
    return completer.future;
  }
  
  Future<String> stopNameService(int port) {
    var completer = new Completer();
    rpc('stop_name_service', [port])
    .then((result) { 
      completer.complete(result[1].toString());
    })
    .catchError((error) => completer.completeError(error));
    
    return completer.future;
  }  
  
  Future<bool> checkNameService() {
    var completer = new Completer();
    rpc('check_name_service', [])
    .then((result) { 
      completer.complete(result[1] == 'Running' ? true : false);
    })
    .catchError((error) => completer.completeError(error));
    
    return completer.future;
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
}


