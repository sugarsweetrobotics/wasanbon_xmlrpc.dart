// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon.example;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart' as wasanbon;
import 'package:xml/xml.dart' as xml;
import 'dart:async';

main() {
  wasanbon.WasanbonRPC rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");

  bool running = false;
  int port = 2809;

  Future.wait([rpc.nameService.checkNameService()])
  .then((retval) {
    print('NameServer is running?? : ${retval[0]}');
    running = retval[0];

    if (running) {
      Future.wait([rpc.nameService.listConnectablePairs(["localhost:2809"])])
      .then((retval) {

        print ("list: ${retval}");

      })
      .catchError((res) {
        print(res);
      });
    } else {

    }


  })
  .catchError((res) {
    print(res);
  });


}
