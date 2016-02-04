// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library wasanbon_xmlrpc.misc;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;

class VersionInfo {
  var version = "0.0";
  var platform = "none";
  VersionInfo(result) {
    this.version = result['version'];
    this.platform = result['platform'];
  }

  String toString() {
    return 'VersionInfo version="${version}" platform="${platform}"';
  }
}



class MiscFunction extends WasanbonRPCBase {

  MiscFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  /// Echo function for test
  Future<String> echo(String code) {
    print('${this.runtimeType}.echo($code)');
    var completer = new Completer();
    rpc('misc_echo', [code]).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  /// Get Version Infomation of wasanbon server
  Future<VersionInfo> version() {
    print('${this.runtimeType}.version()');
    var completer = new Completer();
    rpc('misc_version', []).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(new VersionInfo(result[2]));
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

}