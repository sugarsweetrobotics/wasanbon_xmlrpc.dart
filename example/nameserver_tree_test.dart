// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon.example;
import 'dart:async';
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart' as wasanbon;
import 'package:xml/xml.dart' as xml;

main() {
  var rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");
  bool running = false;
  rpc.nameService.checkNameService()
  .then((retval) {
    print('NameServer is running?? : ${retval}');
    running = retval;

    if (!running) {
      rpc.nameService.startNameService(2809);
    }


    if (running) {
      rpc.nameService.treeNameService()
      .then((info) {
        print("Tree:");
        print(info);
      })
      .catchError((err) => print("Error: ${err}"));
    }
  })
  .catchError((res) {
    print(res);
  });
}
