// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library wasanbon_xmlrpc.base;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;



class PackageInfoPack {
  
  
}

class RTCConfInfo {
  String language = "";
  String path = "";
  yaml.YamlMap value;
  
  RTCConfInfo(this.language, this.path, this.value) {}
  
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


class RtcRepositoryInfo {
  
  String name;
  String url;
  String description;
  String type;
  var platform;
  
  RtcRepositoryInfo(this.name, yaml.YamlMap map) {
    url = map['url'];
    description = map['description'];
    type = map['type'];
    platform = map['platform'];
  }
  
  
}


class WasanbonReturnValue {
  bool success;
  String message;
  var object;
  WasanbonReturnValue(this.success, this.message, this.object);
}


class WasanbonRPCBase {
  String url = "RPC";
  http.Client client = null;
  WasanbonRPCBase({String url:'http://localhost:8000/RPC', http.Client client:null}) {
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
}
