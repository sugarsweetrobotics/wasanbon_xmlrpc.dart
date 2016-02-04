// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.files_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


main() {
  files_test();
}

files_test() {

  test.group('Files Tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    /// ルートディレクトリのリスティングテスト
    test.test('List Directory Test', () async {
      var path = '/';
      var f = rpc.files.listDirectory(path).then((List<String> paths) {
        print (paths);
        test.expect(paths.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test of Listing');
        print(dat);
      });
      test.expect(f, test.completes);
    });

    /// カレントディレクトリ変更テスト
    test.test('Change Directory Test', () async {
      var path = '.';
      var f = rpc.files.changeDirectory(path).then((String new_path) {
        print('Change dir . is $new_path');
        test.expect(new_path.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      });

      test.expect(f, test.completes);
    });

    /// カレントディレクトリ取得テスト
    test.test('Print Current Directory Test', () async {
      test.expect(rpc.files.printWorkingDirectory().then((String path) {
        print('Current dir is ${path}');
        test.expect(path.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      }), test.completes);
    });


    /// ファイル保存テスト
    test.test('Save File Test', () async {
      var filename = 'test_file_name.txt';
      var content = 'This is test file for wasanbon_rpc';

      /// ファイル保存テスト
      test.expect(rpc.files.uploadFile(filename, content).then((String ret) {
        print('Saved File $filename is $ret');
        test.expect(ret == filename, test.isTrue);

        /// ファイル内容確認
        test.expect(rpc.files.downloadFile(filename).then((String ret) {
          print('File content is $ret');
          test.expect(ret == content, test.isTrue);

          /// ファイルの除去
          test.expect(rpc.files.deleteFile(filename).then((String ret) {
            print('File remove is $ret');
            test.expect(ret == filename, test.isTrue);
          }).catchError((dat) {
            test.fail('Exception occured in Removing file.');
            print(dat);
          }), test.completes);

        }).catchError((dat) {
          test.fail('Exception occured in File content verification. ');
          print(dat);
        }), test.completes);

      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Test uploadFile');
      }), test.completes);

    });
  });
}