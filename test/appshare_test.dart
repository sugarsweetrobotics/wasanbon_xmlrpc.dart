// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.appshare_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';

import 'package:logging/logging.dart';

main() {
  appshare_test();
}

appshare_test() {
  test.group('AppShare tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.WARNING;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });

    test.test('List Test', () async {
      var completer = new Completer();
      Future f = rpc.appshare.list();
      f.then( (List msg) {
         msg.forEach((v) {
           print (v);
         });
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Echo test');
      });
      return f;
    });

  });
}