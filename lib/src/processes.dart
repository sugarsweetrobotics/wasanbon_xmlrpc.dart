// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library wasanbon_xmlrpc.processes;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;


class Process {
  String name;
  int id;

  Process(this.name, this.id) {}

}


class ProcessesFunction extends WasanbonRPCBase {

  ProcessesFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  Future<Process> run(String filename, {List<String> args : null }) {
    if (args == null) args = [];


    print('${this.runtimeType}.run($filename, ${args})');
    var completer = new Completer();
    rpc('processes_run', [filename, args]).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(new Process(result[2][0], result[2][1]));
      else completer.complete(null);
    }).catchError((error) {
    print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

}