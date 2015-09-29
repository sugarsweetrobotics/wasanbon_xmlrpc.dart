


library wasanbon_xmlrpc.admin;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;
import 'base.dart';


class VersionInfo {
  var version = "0.0";
  var platform = "none";
  VersionInfo(result) {
    this.version = result[1]['wasanbon'];
    this.platform = result[1]['platform'];
  }

  String toString() {
    return 'VersionInfo version="${version}" platform="${platform}"';
  }

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

  String toString() {
    return 'PackageInfo name="${name}" description="${description}"';
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
    return 'PackageReposiotryInfo name="${name}" url="${url}" description="${description}"';
  }
}

class AdminFunction extends WasanbonRPCBase {

  AdminFunction({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

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


  Future<List<PackageRepositoryInfo>> getPackageRepositories() {
    var completer = new Completer();
    rpc('package_repositories', [])
    .then((result) {
      List<PackageRepositoryInfo> infoList = new List<PackageRepositoryInfo>();
      yaml.YamlMap map = yaml.loadYaml(result[1]);
      map.keys.forEach((key) {
        infoList.add(new PackageRepositoryInfo(key, map[key]));
      });
      infoList.sort((PackageRepositoryInfo a, PackageRepositoryInfo b) => a.name.compareTo(b.name));

      completer.complete(infoList);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<String> deletePackage(pkg) {
    var completer = new Completer();
    rpc('delete_package', [pkg])
    .then((result) {
      completer.complete(result);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }

  Future<String> clonePackage(pkg) {
    var completer = new Completer();
    rpc('clone_package', [pkg])
    .then((result) {
      completer.complete(result);
    })
    .catchError((error) => completer.completeError(error));

    return completer.future;
  }
}