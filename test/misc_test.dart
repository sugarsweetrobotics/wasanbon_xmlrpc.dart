// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon.example;

import 'dart:async';
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart' as wasanbon;
import 'package:xml/xml.dart' as xml;


var code = """
print 'Hello World'
""";

main() {
  var rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");

  rpc.misc.sendCode(code).then((String filename) {
    rpc.misc.startCode(filename)
        .then((flag) => print(flag))
        .catchError((dat) => print(dat));

  }).catchError((dat) => print(dat));

}