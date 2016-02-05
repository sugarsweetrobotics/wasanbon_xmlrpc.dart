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
      var completer = new Completer();
      var yahoo = 'Hello';
      Future f = rpc.misc.echo(yahoo);
      f.then( (var msg) {
        print('msg is $msg');
        test.expect(yahoo == msg, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Echo test');
      });
      return f;
    });

    test.test('Version Test', () async {
      Future f = rpc.misc.version();
      f.then( (VersionInfo v) {
        print('Version if $v');
        test.expect(v != null, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Version test');
      });
      return f;
    });
  });
}