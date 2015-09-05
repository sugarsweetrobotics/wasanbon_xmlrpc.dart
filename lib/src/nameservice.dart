

library wasanbon_xmlrpc.nameservice;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml_rpc/client.dart' as xmlrpc;
import 'package:yaml/yaml.dart' as yaml;


class Node {
  Node parent;
  String name;
  List<Node> children;
  String value = null;
  Node(this.parent, this.name) {
    children = new List<Node>();
  }

  int getDepth() {
    if (parent == null) {
      return 0;
    } else {
      return parent.getDepth() + 1;
    }
  }


  String toString() {
    String str;
    str = "  " * getDepth() + name + ' : ';
    if (value != null) {
      str = str + value + '\n';
    } else {
      if (children.length == 0) {
        str += "{}\n";
      } else {
        str += '\n';
      }

      for(var c in children) {
        str += c.toString();
      }
    }
    return str;
  }
}

class HostContext extends Node {
  HostContext(Node parent, String name) : super(parent, name) {
  }
}

class Component extends Node {
  Component(Node parent, String name) : super(parent, name) {
  }


}

class NameService extends Node {
  NameService(Node parent, String name) : super(parent, name) {
  }
}

bool isHostContext(String key) {
  return key.endsWith('.host_cxt');
}

bool isComponent(String key) {
  return key.endsWith('.rtc');
}

void nameServiceParserSub(Node parent, yaml.YamlMap map) {
  for (String key in map.keys) {
    Node node;
    if (isHostContext(key)) {
      node = new HostContext(parent, key);
    } else if (isComponent(key)) {
      node = new Component(parent, key);
    } else {
      node = new Node(parent, key);
    }

    if (map[key] is yaml.YamlMap) {
      nameServiceParserSub(node, map[key]);
      parent.children.add(node);
    } else {
      node.value = map[key];
      parent.children.add(node);
    }
  }
}

List<Node> nameServiceParser(yaml.YamlMap map) {
  List<Node> nodes = new List<Node>();
  for(String ns in map.keys) {
    Node root = new NameService(null, ns);
    nameServiceParserSub(root, map[ns]);
    nodes.add(root);
  }
  return nodes;
}




class NameServerInfo {

  List<Node> nameServers;
  NameServerInfo(yaml.YamlMap map) {
    print (map);
    nameServers  = nameServiceParser(map);
  }


  String toString() {
    String str = "";
    for(var ns in nameServers) {
      str += ns.toString() + '\n';
    }
    return str;
  }
}


class NameServiceFunction extends WasanbonRPCBase {

  NameServiceFunction ({String url:'http://localhost:8000/RPC', http.Client client:null}) : super(url:url, client:client) {

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

  Future<bool> treeNameService() {
    var completer = new Completer();
    rpc('tree_name_service', [2809])
    .then((result) {
      print(result);
      completer.complete(new NameServerInfo(yaml.loadYaml(result[1])));
    })
    .catchError((error) => completer.completeError(error));


    return completer.future;
  }

}