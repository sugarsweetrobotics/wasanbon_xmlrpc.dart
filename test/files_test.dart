// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.files_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


files_test() {



  test.group('Files Tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    /// ルートディレクトリのリスティングテスト
    test.test('List Directory Test', () async {
      var path = '/';
      var f = rpc.files.listDirectory(path).then((var lst) {
        print (lst);
        test.expect(lst.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      });
      test.expect(f, test.completes);
    });

    /// カレントディレクトリ変更テスト
    test.test('Change Directory Test', () async {
      var path = '.';
      var f = rpc.files.changeDirectory(path).then((var pwd) {
        print('Change dir . is $pwd');
        test.expect(pwd.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      });

      test.expect(f, test.completes);
    });

    /// カレントディレクトリ取得テスト
    test.test('Print Current Directory Test', () async {
      test.expect(rpc.files.printWorkingDirectory().then((var pwd) {
        print('Current dir is $pwd');
        test.expect(pwd.length > 0, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      }), test.completes);
    });


    test.test('Save File Test', () async {
      var filename = 'test_file_name.txt';
      var content = 'This is test file for wasanbon_rpc';

      /// ファイル保存テスト
      test.expect(rpc.files.uploadFile(filename, content).then((var ret) {
        print('Saved File $filename is $ret');
        test.expect(ret, test.isTrue);

        /// ファイル内容確認
        test.expect(rpc.files.downloadFile(filename).then((var ret) {
          print('File content is $ret');
          test.expect(ret == content, test.isTrue);

          /// ファイルの除去
          test.expect(rpc.files.deleteFile(filename).then((var ret) {
            print('File remove is $ret');
            test.expect(ret, test.isTrue);
          }).catchError((dat) {
            test.fail('Exception occured in File content verification.');
            print(dat);
          }), test.completes);

        }).catchError((dat) {
          test.fail('Exception occured in Removing file. ');
          print(dat);
        }), test.completes);

      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      }), test.completes);

    });
  });
}