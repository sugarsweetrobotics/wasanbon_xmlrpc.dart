// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.misc_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';

import 'package:logging/logging.dart';

main() {
  setting_test();
}

setting_test() {
  test.group('Setting tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.WARNING;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });


    /// エコーバックテスト
    test.test('Echo Test', () async {
      var yahoo = 'Hello';
      Future f = rpc.setting.echo(yahoo);
      f.then( (var msg) {
        print('msg is $msg');
        test.expect(yahoo == msg, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Echo test');
      });
      return f;
    });

    /// パッケージリスティング
    test.test('List Package', () async {
      Future f = rpc.setting.readyPackages();
      f.then( (var msg) {
        print('Packages are $msg');
        test.expect(msg.length > 0, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Echo test');
      });
      return f;
    });

    /// Upload File to package dir
    test.test('Uplaod Package', () async {
      var package_name = 'test_package';

      var content = 'hoge';
      Future f = rpc.setting.uploadPackage(package_name, content).then( (var msg) {
        return rpc.setting.readyPackages();
      }).then( (List<String> lst) {

        print('Packages are $lst');
        test.expect(lst.indexOf(package_name) >= 0, test.isTrue);
        return rpc.setting.removePackage(package_name);
      }).then( (var msg) {
        print('Packages are $msg');
        return rpc.setting.readyPackages();
      });


      f.then( (List<String> lst) {
        print('Packages are $lst');
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Upload test');
      });
      return f;
    });


  });
}