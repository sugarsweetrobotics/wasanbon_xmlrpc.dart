// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon.example;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart' as wasanbon;
import 'package:xml/xml.dart' as xml;

main() {
  wasanbon.WasanbonRPC rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");
  
  rpc.admin.getPackageRepositories()
  .then((infoList) {
    for (var info in infoList) {
      print('- ${info}');
    }
  })
  .catchError((res) { 
    print(res);
  });
  
}