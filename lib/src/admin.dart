


library wasanbon_xmlrpc.admin;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;
import 'base.dart';



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
  }
}


class PackageRepositoryInfo {

  String name;
  String url;
  String description;
  String type;
  var platform;

  PackageRepositoryInfo(this.name, yaml.YamlMap map) {
    url = map['url'];
    description = map['description'];
    type = map['type'];
    platform = map['platform'];
  }

  String toString() {
    return name;
    //return 'PackageReposiotryInfo name="${name}" url="${url}" description="${description}"';
  }
}


/// 管理機能
class AdminFunction extends WasanbonRPCBase {

  AdminFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

  }


  /// Get Package Info List of wasanbon server
  Future<List<PackageInfo>> getPackageList() {
    print('${this.runtimeType}.getPackageList()');
    var completer = new Completer();
    rpc('admin_package_list', []).then((result) {
      print(' - $result');
      yaml.YamlMap res = yaml.loadYaml(result[2]);
      List<PackageInfo> pkgs = [];
      for(String name in res.keys) {
        pkgs.add(new PackageInfo(name, res[name]));
      }
      pkgs.sort((a, b) => a.name.compareTo(b.name));
      completer.complete(pkgs);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    } );
    return completer.future;
  }

  /// Get Package Repository List
  Future<List<PackageRepositoryInfo>> getPackageRepositoryList() {
    print('${this.runtimeType}.getPackageRepositoryList()');
    var completer = new Completer();
    rpc('admin_repository_list', []).then((result) {
      print(' - $result');
      List<PackageRepositoryInfo> infoList = new List<PackageRepositoryInfo>();
      yaml.YamlMap map = yaml.loadYaml(result[2]);
      map.keys.forEach((key) {
        infoList.add(new PackageRepositoryInfo(key, map[key]));
      });
      infoList.sort((PackageRepositoryInfo a, PackageRepositoryInfo b) => a.name.compareTo(b.name));

      completer.complete(infoList);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    } );
    return completer.future;
  }


  Future<String> clonePackageRepository(String repoName) {
    var completer = new Completer();
    rpc('admin_repository_clone', [repoName])
        .then((result) {
      completer.complete(result);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }


  Future<String> deletePackage(pkg) {
    var completer = new Completer();
    rpc('admin_package_delete', [pkg])
        .then((result) {
      completer.complete(result);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }



  /// Get Running Package Info List of wasanbon server
  Future<List<PackageInfo>> getRunningPackageInfos() {
    var completer = new Completer();
    rpc('running_packages', [])
    .then((result) {
      yaml.YamlMap res = yaml.loadYaml(result[1]);

      List<PackageInfo> pkgs = [];
      if(res != null) {

        for (String name in res.keys) {
          pkgs.add(new PackageInfo(name, res[name]));
        }
        pkgs.sort((a, b) => a.name.compareTo(b.name));
      }
      completer.complete(pkgs);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }







}