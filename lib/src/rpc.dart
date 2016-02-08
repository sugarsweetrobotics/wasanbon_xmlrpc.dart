

library wasanbon_xmlrpc.rpc;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;

import 'adminPackage.dart';
import 'adminRepository.dart';
import 'nameservice.dart';
import 'rtc.dart';
import 'mgrRtc.dart';
import 'mgrRepository.dart';
import 'system.dart';
import 'misc.dart';
import 'files.dart';
import 'processes.dart';

class WasanbonRPC {


  AdminRepositoryFunction adminRepository;
  AdminPackageFunction adminPackage;
  NameServiceFunction nameService;
  RtcFunction rtc;
  SystemFunction system;
  MgrRtcFunction mgrRtc;
  MiscFunction misc;
  FilesFunction files;
  ProcessesFunction processes;
  MgrRepositoryFunction mgrRepository;

  WasanbonRPC({String url:'http://localhost:8000/RPC', http.Client client:null}) {
    adminPackage = new AdminPackageFunction(url: url, client: client);
    adminRepository = new AdminRepositoryFunction(url: url, client: client);
    nameService = new NameServiceFunction(url: url, client: client);
    rtc = new RtcFunction(url: url, client: client);
    system = new SystemFunction(url: url, client: client);
    mgrRtc = new MgrRtcFunction(url: url, client: client);
    mgrRepository = new MgrRepositoryFunction(url: url, client: client);
    misc = new MiscFunction(url:url, client: client);
    files = new FilesFunction(url:url, client:client);
    processes = new ProcessesFunction(url:url, client:client);
  }

  onRecordListen(var func) {
    adminPackage.logger.onRecord.listen(func);
    adminRepository.logger.onRecord.listen(func);
    nameService.logger.onRecord.listen(func);
    rtc.logger.onRecord.listen(func);
    system.logger.onRecord.listen(func);
    mgrRtc.logger.onRecord.listen(func);
    mgrRepository.logger.onRecord.listen(func);
    misc.logger.onRecord.listen(func);
    files.logger.onRecord.listen(func);
    processes.logger.onRecord.listen(func);
  }

}


