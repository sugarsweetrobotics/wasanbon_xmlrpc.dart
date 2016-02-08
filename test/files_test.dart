// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.files_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';
import 'package:logging/logging.dart';

main() {
  files_test();
}

files_test() {

  test.group('Files Tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.WARNING;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });

    /// ルートディレクトリのリスティングテスト
    test.test('List Directory Test', () async {
      var path = '/';
      var f = rpc.files.listDirectory(path);

      f.then((List<String> paths) {
        print (paths);
        test.expect(paths.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test of Listing');
        print(dat);
      });

      return f;
    });

    /// カレントディレクトリ変更テスト
    test.test('Change Directory Test', () async {
      var path = '.';
      var f = rpc.files.changeDirectory(path);

      f.then((String new_path) {
        print('Change dir . is $new_path');
        test.expect(new_path.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      });

      return f;
    });

    /// カレントディレクトリ取得テスト
    test.test('Print Current Directory Test', () {
      Future f = rpc.files.printWorkingDirectory();

      f.then((String path) {
        print('Current dir is ${path}');
        test.expect(path.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      });

      return f;
    });


    /// ファイル保存テスト
    test.test('Save File Test', () {
      var filename = 'test_file_name.txt';
      var content = 'This is test file for wasanbon_rpc';

      /// ファイル保存テスト
      Future f = rpc.files.uploadFile(filename, content).then((String ret) {
        print('Saved File $filename is $ret');
        test.expect(ret == filename, test.isTrue);

        /// ファイル内容確認
        return rpc.files.downloadFile(filename);
      }).then((String ret) {
        print('File content is $ret');
        test.expect(ret == content, test.isTrue);

        /// ファイルの除去
        return rpc.files.deleteFile(filename);
      });

      f.then((String ret) {
        print('File remove is $ret');
        test.expect(ret == filename, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Test uploadFile');
      });

      return f;
    });
  });
}