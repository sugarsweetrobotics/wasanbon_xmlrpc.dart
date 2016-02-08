// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.processes_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';

import 'package:logging/logging.dart';


main () {
  processes_test();
}
processes_test() {

  /// プロセス管理テスト
  test.group('Processes', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.ALL;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });

    test.test('Python script run test', () async {
      var filename = 'test_file_name.py';
      var content = 'print "Hello World. This is Python script"';

      /// Pythonスクリプトを送信
      Future f = rpc.files.uploadFile(filename, content).then((var ret) {
        print('Saved File $filename is $ret');
        test.expect(ret == filename, test.isTrue);

        /// Pythonスクリプトの内容確認
        return rpc.files.downloadFile(filename);
      }).then((var ret) {
        print('File content is $ret');
        test.expect(ret == content, test.isTrue);

        /// Pythonスクリプトの実行
        return rpc.processes.run(filename);
      }).then((var ret) {
        print('Process Run is $ret');
        test.expect(ret != null, test.isTrue);

        /// Pythonスクリプトの除去
        return rpc.files.deleteFile(filename);
      });

      f.then((var ret) {
        print('File remove is $ret');
        test.expect(ret == filename, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Test');
      });

      return f;

    });
  });

}