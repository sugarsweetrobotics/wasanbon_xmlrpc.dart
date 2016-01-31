// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.processes_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


processes_test() {

  /// プロセス管理テスト
  test.group('Processes', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    test.test('Save file test', () async {
      var filename = 'test_file_name.py';
      var content = 'print "Hello World. This is Python script"';

      /// Pythonスクリプトを送信
      test.expect(rpc.files.uploadFile(filename, content).then((var ret) {
        print('Saved File $filename is $ret');
        test.expect(ret, test.isTrue);

        /// Pythonスクリプトの内容確認
        test.expect(rpc.files.downloadFile(filename).then((var ret) {
          print('File content is $ret');
          test.expect(ret == content, test.isTrue);

          /// Pythonスクリプトの実行
          test.expect(rpc.processes.run(filename).then((var ret) {
            print('Process Run is $ret');
            test.expect(ret, test.isTrue);

            /// Pythonスクリプトの除去
            test.expect(rpc.files.deleteFile(filename).then((var ret) {
              print('File remove is $ret');
              test.expect(ret, test.isTrue);
            }).catchError((dat) {
              test.fail('Exception occured in removing Script');
              print(dat);
            }), test.completes);


          }).catchError((dat) {
            test.fail('Exception occured in processes_run ');
            print(dat);
          }), test.completes);

        }).catchError((dat) {
          test.fail('Exception occured in content verification.');
          print(dat);
        }), test.completes);

      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      }), test.completes);

    });
  });

}