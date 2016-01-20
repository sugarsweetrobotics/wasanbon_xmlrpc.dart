

library wasanbon_xmlrpc.rpc;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;

import 'admin.dart';
import 'nameservice.dart';
import 'rtc.dart';
import 'package.dart';
import 'system.dart';
import 'misc.dart';

class WasanbonRPC {

  AdminFunction admin;
  NameServiceFunction nameService;
  RtcFunction rtc;
  SystemFunction system;
  PackageFunction package;
  MiscFunction misc;

  WasanbonRPC({String url:'http://localhost:8000/RPC', http.Client client:null}) {
    admin = new AdminFunction(url: url, client: client);
    nameService = new NameServiceFunction(url: url, client: client);
    rtc = new RtcFunction(url: url, client: client);
    system = new SystemFunction(url: url, client: client);
    package = new PackageFunction(url: url, client: client);
    misc = new MiscFunction(url:url, client: client);
  }



}


