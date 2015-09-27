

library wasanbon_xmlrpc.nameservice;
import "base.dart";
import 'dart:async';
import 'dart:collection';
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


  Node resolve(String path) {
    bool recur = false;
    while(path.startsWith('/')) {
      path = path.substring(1);
    }
    var objPath = path;
    if(path.indexOf('/') >= 0) {
      objPath = path.split('/')[0];
      recur = true;
    }

    if(path.indexOf(':') >= 0) {
      objPath = path.split(':')[0];
      recur = true;
    }
    for(Node node in children) {
      if (node.name == objPath) {
        if(recur) {
          return node.resolve(path.substring(objPath.length));
        } else {
          return node;
        }
      }
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

  Node getRootNode() {
    if(parent == null) {
      return this;
    } else {
      return parent.getRootNode();
    }
  }
}

class HostContext extends Node {
  HostContext(Node parent, String name, yaml.YamlMap map) : super(parent, name) {
    print("Host ${name}");
    nameServiceParserSub(this, map);
  }
}


class Properties extends Node {
  yaml.YamlMap map;
  Properties(Node parent, String name, yaml.YamlMap map) : super(parent, name) {
    this.map = map;
    for(String key in map.keys) {
      children.add(new Node(this, key) ..value = map[key]);
    }
  }

  String operator[](String key) {
    return map[key];
  }

}

class Connection extends Node {
  String id;
  Properties properties;
  List<String> _ports = [];

  PortList get ports {
    return new PortList(this, 'ports')
    ..add((getRootNode() as NameServiceList).resolve(_ports[0]))
    ..add((getRootNode() as NameServiceList).resolve(_ports[1]));
  }

  Connection(Node parent, String name, yaml.YamlMap map) : super(parent, name) {
    print('Connection ${name}');
    for(String key in map.keys) {
      if (key == 'id') {
        this.id =  map[key];
      } else if (key == 'properties' ){
        properties = new Properties(this, 'properties', map[key]);
        children.add(properties);
      } else if (key == 'ports') {
        _ports.add(map[key][0]);
        _ports.add(map[key][1]);
      }
    }
  }

  String toString() {
    String str;
    str = "  " * getDepth() + name + ' : \n';
    str += "  " * (getDepth()  + 1) + 'id : ' + id +'\n';

    str += "  " * (getDepth()  + 1) + 'ports : \n';
    str += "  " * (getDepth()  + 2) + '- ${_ports[0]} \n';
    str += "  " * (getDepth()  + 2) + '- ${_ports[1]} \n';
    if (children.length == 0) {
      str += "{}\n";
    }

    for(var c in children) {
      str += c.toString();
    }

    return str;
  }
}


class Connections extends Node with ListMixin {
  List<Connection> list = [];

  void set length(int newLength) {list.length = newLength;}
  int get length => list.length;
  Connection operator[](int index) => list[index];
  void operator[]=(int index, Connection value) {list[index] = value;}
  void add(Connection child) {list.add(child);}

  Connections(Node parent, String name, yaml.YamlMap map) : super(parent, name) {
    if (map != null) {
      for(String key in map.keys) {
        list.add(new Connection(this, key, map[key]));
      }
    }
  }

  String toString() {
    String str;
    str = "  " * getDepth() + name + ' : ';
    if (length == 0) {
      str += "{}\n";
    } else {
      str += '\n';
    }
    for(var c in list) {
      str += c.toString();
    }

    return str;
  }
}

class PortBase extends Node {
  yaml.YamlMap map;
  Properties properties;
  Connections connections;

  PortBase(Node parent, String name, yaml.YamlMap map) : super(parent, name) {
    this.map = map;
    for(String key in map.keys) {
      if (key == 'properties') {
        this.properties = new Properties(this, 'properties', map[key]);
        this.children.add(properties);
      } else if (key == 'connections') {
        this.connections = new Connections(this, 'connections', map[key]);
        this.children.add(connections);
      }
    }
  }
}

class DataOutPort extends PortBase {
  DataOutPort(Node parent, String name, yaml.YamlMap map) : super(parent, name, map) {

  }
}

class DataInPort extends PortBase {
  DataInPort(Node parent, String name, yaml.YamlMap map) : super(parent, name, map) {

  }
}

class ServicePort extends PortBase {
  ServicePort(Node parent, String name, yaml.YamlMap map) : super(parent, name, map) {

  }
}

class PortList extends Node with ListMixin<PortBase> {

  List<PortBase> list = [];
  PortList(Node parent, String name) : super(parent, name) {
  }

  void set length(int newLength) {list.length = newLength;}
  int get length => list.length;
  PortBase operator[](int index) => list[index];
  void operator[]=(int index, PortBase value) {list[index] = value;}
  void add(PortBase child) {list.add(child);}

  String toString() {
    String str;
    str = "  " * getDepth() + name + ' : ';
    if (length == 0) {
      str += "{}\n";
    } else {
      str += '\n';
    }

    for(var c in list) {
      str += c.toString();
    }

    return str;
  }
}

class Component extends Node {

  PortList inPorts;
  PortList outPorts;
  PortList servicePorts;

  Properties properties;

  Component(Node parent, String name, yaml.YamlMap map) : super(parent, name) {
    print("Component ${name}");
    inPorts = new PortList(this, "DataInPort");
    outPorts = new PortList(this, "DataOutPort");
    servicePorts = new PortList(this, "ServicePorts");
    this.children.add(inPorts);
    this.children.add(outPorts);
    this.children.add(servicePorts);
    for(String key in map.keys) {
      if (key == "DataOutPorts") {
        parseOutPorts(map[key]);
      } else if (key == "DataInPorts") {
        parseInPorts(map[key]);
      } else if (key == "ServicePorts") {
        parseServicePorts(map[key]);
      } else if (key == "properties") {
        properties = new Properties(this, "properties", map[key]);
        this.children.add(properties);
      }
    }


  }

  Node resolve(String path) {
    bool recur = false;
    while(path.startsWith('/')) {
      path = path.substring(1);
    }
    while(path.startsWith(':')) {
      path = path.substring(1);
    }

    for(Node node in outPorts) {
      if (node.name == path) {
        return node;
      }
    }
    for(Node node in inPorts) {
      if (node.name == path) {
        return node;
      }
    }
    for(Node node in servicePorts) {
      if (node.name == path) {
        return node;
      }
    }

    return null;
  }

  void parseOutPorts(yaml.YamlMap map) {
    for(String key in map.keys) {
      outPorts.add(new DataOutPort(outPorts, key, map[key]));
    }

  }

  void parseInPorts(yaml.YamlMap map) {
    for(String key in map.keys) {
      inPorts.add(new DataInPort(inPorts, key, map[key]));
    }

  }

  void parseServicePorts(yaml.YamlMap map) {
    for(String key in map.keys) {
      servicePorts.add(new ServicePort(servicePorts, key, map[key]));
    }

  }
}

class NameService extends Node {
  NameService(Node parent, String name) : super(parent, name) {
  }

}


class NameServiceList extends Node with ListMixin<NameService> {

  List<NameService> list = [];
  NameServiceList(Node parent, String name) : super(parent, name) {

  }

  void set length(int newLength) {list.length = newLength;}
  int get length => list.length;
  NameService operator[](int index) => list[index];
  void operator[]=(int index, NameService value) {list[index] = value;}
  void add(NameService child) {list.add(child);}

  Node resolve(String path) {
    while(path.startsWith('/')) {
      path = path.substring(1);
    }

    String nsPath = path.split('/')[0];
    NameService ns = find(nsPath);
    if (ns != null) {
      return ns.resolve(path.substring(nsPath.length));
    }

    return null;
  }

  NameService find(String path) {
    if (path.indexOf(':') < 0) {
      path = path + ':2809';
    }
    if (!path.startsWith('/')) {
      path = '/' + path;
    }
    for(NameService ns in list) {
      if(ns.name == path) {
        return ns;
      }
    }
    return null;
  }



  String toString() {
    String str;
    str = "  " * getDepth() + name + ' : ';
    if (length == 0) {
      str += "{}\n";
    } else {
      str += '\n';
    }

    for(var c in list) {
      str += c.toString();
    }

    return str;
  }
}


class Manager extends Node {
  Manager(Node parent, String name, yaml.YamlMap map) : super(parent, name) {
    print("Manager ${name}");
  }
}

bool isHostContext(String key) {
  return key.endsWith('.host_cxt');
}

bool isComponent(String key) {
  return key.endsWith('.rtc');
}

bool isManager(String key) {
  return key.endsWith('.mgr');
}

void nameServiceParserSub(Node parent, yaml.YamlMap map) {
  for (String key in map.keys) {
    Node node;
    if (isHostContext(key)) {
      node = new HostContext(parent, key, map[key]);
    } else if (isComponent(key)) {
      node = new Component(parent, key, map[key]);
    } else if (isManager(key)) {
      node = new Manager(parent, key, map[key]);
    } else {
      node = new Node(parent, key);
    }

    parent.children.add(node);
  }
}

NameServiceList nameServiceParser(yaml.YamlMap map) {
  NameServiceList nodes = new NameServiceList(null, "NameServers");
  for(String ns in map.keys) {
    Node root = new NameService(nodes, ns);
    nameServiceParserSub(root, map[ns]);
    nodes.add(root);
  }
  return nodes;
}




class NameServerInfo {

  NameServiceList nameServers;
  NameServerInfo(yaml.YamlMap map) {
    //print (map);
    nameServers  = nameServiceParser(map);
  }


  String toString() {
   return nameServers.toString();
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
      completer.complete(result[1].indexOf('Running') >= 0 ? true : false);
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