// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library wasanbon_xmlrpc.misc;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;


class MiscFunction extends WasanbonRPCBase {

  MiscFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  /**
   * code : Code
   * return : filename
   */
  Future<String> sendCode(String code) {
    var completer = new Completer();
    rpc('misc_send_code', [code]).then((result) {
      completer.complete(result[1].toString());
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<bool> startCode(String filename) {
    var completer = new Completer();
    rpc('misc_start_code', [filename]).then((result) {
      completer.complete(result[0]);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<String> killCode(String filename) {
    var completer = new Completer();
    rpc('misc_kill_code', []).then((result) {
      completer.complete(result[1].toString());
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<String> readStdout() {
    var completer = new Completer();
    rpc('misc_read_stdout', []).then((result) {
      completer.complete(result[1].toString());
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<String> communicate() {
    var completer = new Completer();
    rpc('misc_communicate', []).then((result) {
      completer.complete(result[1].toString());
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

}