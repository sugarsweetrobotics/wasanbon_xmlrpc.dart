


library wasanbon_xmlrpc.adminRepository;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;
import 'package:xml/xml.dart' as xml;
import 'base.dart';
import 'package:logging/logging.dart';




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



/// リポジトリ管理機能
class AdminRepositoryFunction extends WasanbonRPCBase {

  AdminRepositoryFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  /// Get Package Repository List
  Future<List<PackageRepositoryInfo>> list() {
    print('${this.runtimeType}.getPackageRepositoryList()');
    var completer = new Completer();
    rpc('adminRepository_list', []).then((result) {
      print(' - $result');
      List<PackageRepositoryInfo> infoList = new List<PackageRepositoryInfo>();
      yaml.YamlMap map = yaml.loadYaml(result[2]);
      map.keys.forEach((key) {
        infoList.add(new PackageRepositoryInfo(key, map[key]));
      });
      infoList.sort((PackageRepositoryInfo a, PackageRepositoryInfo b) =>
          a.name.compareTo(b.name));

      completer.complete(infoList);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> clone(String repoName) {
    var completer = new Completer();
    rpc('adminRepository_clone', [repoName])
        .then((result) {
      completer.complete(result);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
