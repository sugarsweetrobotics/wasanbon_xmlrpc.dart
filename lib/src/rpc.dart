

library wasanbon_xmlrpc.rpc;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;

import 'admin.dart';
import 'nameservice.dart';
import 'rtc.dart';
import 'mgrRtc.dart';
import 'mgrRepository.dart';
import 'system.dart';
import 'misc.dart';
import 'files.dart';
import 'processes.dart';

class WasanbonRPC {

  AdminFunction admin;
  NameServiceFunction nameService;
  RtcFunction rtc;
  SystemFunction system;
  MgrRtcFunction mgrRtc;
  MiscFunction misc;
  FilesFunction files;
  ProcessesFunction processes;
  MgrRepositoryFunction mgrRepository;

  WasanbonRPC({String url:'http://localhost:8000/RPC', http.Client client:null}) {
    admin = new AdminFunction(url: url, client: client);
    nameService = new NameServiceFunction(url: url, client: client);
    rtc = new RtcFunction(url: url, client: client);
    system = new SystemFunction(url: url, client: client);
    mgrRtc = new MgrRtcFunction(url: url, client: client);
    mgrRepository = new MgrRepositoryFunction(url: url, client: client);
    misc = new MiscFunction(url:url, client: client);
    files = new FilesFunction(url:url, client:client);
    processes = new ProcessesFunction(url:url, client:client);
  }



}


