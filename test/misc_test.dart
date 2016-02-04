// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.misc_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


main() {
  misc_test();
}

misc_test() {
  test.group('Misc tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    /// エコーバックテスト
    test.test('Echo Test', () async {
      var yahoo = 'Hello';
      Future f = rpc.misc.echo(yahoo).then( (var msg) {
        print('msg is $msg');
        test.expect(yahoo == msg, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Echo test');
      });
      test.expect(f, test.completes);
    });

    test.test('Version Test', () async {
      Future f = rpc.misc.version().then( (VersionInfo v) {
        print('Version if $v');
        test.expect(v != null, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Version test');
      });
      test.expect(f, test.completes);
    });
  });
}