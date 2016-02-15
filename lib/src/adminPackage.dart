


library wasanbon_xmlrpc.adminPackage;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;
import 'base.dart';
import 'package:logging/logging.dart';


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
  bool running = false;

  bool isRunning() {return running;}

  List<String> rtcNames = new List<String>();

  String toString() {
    return name;
//    return 'PackageInfo name="${name}" description="${description}"';
  }


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
    this.running = result['running'];
  }
}


/// 管理機能
class AdminPackageFunction extends WasanbonRPCBase {

  AdminPackageFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }

  /// Get Package Info List of wasanbon server
  Future<List<PackageInfo>> list({bool running: false}) {
    logger.fine('${this.runtimeType}.getPackageList(running: $running)');
    var completer = new Completer();
    rpc('adminPackage_list', [running]).then((result) {
      logger.finer(' - $result');
      yaml.YamlMap res = yaml.loadYaml(result[2]);
      List<PackageInfo> pkgs = [];
      for(String name in res.keys) {
        pkgs.add(new PackageInfo(name, res[name]));
      }
      pkgs.sort((a, b) => a.name.compareTo(b.name));
      completer.complete(pkgs);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    } );
    return completer.future;
  }




  Future<String> delete(String packageName) {
    logger.fine('${this.runtimeType}.delete($packageName)');
    var completer = new Completer();
    rpc('adminPackage_delete', [packageName]).then((result) {
      logger.finer(' - $result');
      completer.complete(result);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    } );

    return completer.future;
  }



  /// Get Running Package Info List of wasanbon server
  Future<List<PackageInfo>> getRunningPackageInfos() {
    logger.fine('${this.runtimeType}.getRunningPackageInfos()');
    var completer = new Completer();
    rpc('adminPackage.running_packages', []).then((result) {
      logger.finer(' - $result');
      yaml.YamlMap res = yaml.loadYaml(result[1]);
      List<PackageInfo> pkgs = [];
      if(res != null) {
        for (String name in res.keys) {
          pkgs.add(new PackageInfo(name, res[name]));
        }
        pkgs.sort((a, b) => a.name.compareTo(b.name));
      }
      completer.complete(pkgs);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    } );

    return completer.future;
  }

}