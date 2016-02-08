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

  test.group('Files Tests', ()
  {
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
        print(paths);
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
      var filename = 'save_test_file_name.txt';
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


    /// ファイルコピーテスト
    test.test('Copy File Test', () {
      var filename = 'copy_test_file_name.txt';
      var dstFilename = 'copy_test_file_name2.txt';
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

        /// ファイルのコピー
        return rpc.files.copyFile(filename, dstFilename);
      }).then((String ret) {
        print('Saved File $dstFilename is $ret');
        test.expect(ret == dstFilename, test.isTrue);

        /// ファイル内容確認
        return rpc.files.downloadFile(dstFilename);
      }).then((String ret) {
        print('File content is $ret');
        test.expect(ret == content, test.isTrue);

        var path = '.';
        return rpc.files.listDirectory(path);
      }).then((List<String> paths) {
        test.expect(paths.indexOf(dstFilename) >= 0, test.isTrue);
        test.expect(paths.indexOf(filename) >= 0, test.isTrue);

        /// ファイルの除去
        return rpc.files.deleteFile(filename);
      }).then((String ret) {
        test.expect(ret == filename, test.isTrue);

        /// ファイルの除去
        return rpc.files.deleteFile(dstFilename);
      });


      f.then((String ret) {
        print('File remove is $ret');
        test.expect(ret == dstFilename, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Test uploadFile');
      });

      return f;
    });

    /// ファイル名前変更テスト
    test.test('Rename File Test', () {
      var filename = 'rename_test_file_name.txt';
      var dstFilename = 'rename_test_file_name2.txt';
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

        /// ファイルのコピー
        return rpc.files.renameFile(filename, dstFilename);
      }).then((String ret) {
        print('Saved File $dstFilename is $ret');
        test.expect(ret == dstFilename, test.isTrue);

        /// ファイル内容確認
        return rpc.files.downloadFile(dstFilename);
      }).then((String ret) {
        print('File content is $ret');
        test.expect(ret == content, test.isTrue);

        var path = '.';
        return rpc.files.listDirectory(path);
      }).then((List<String> paths) {
        test.expect(paths.indexOf(dstFilename) >= 0, test.isTrue);
        test.expect(paths.indexOf(filename) < 0, test.isTrue);

        /// ファイルの除去
        return rpc.files.deleteFile(dstFilename);
      });

      f.then((String ret) {
        print('File remove is $ret');
        test.expect(ret == dstFilename, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Test uploadFile');
      });

      return f;
    });

    /// ディレクトリ作成テスト
    test.test('Make Directory Test', () {
      var filename = 'dir_test_dir_name';

      /// ディレクトリ確認
      Future f = rpc.files.listDirectory('.').then((List<String> ret) {
        int counter = 2;
        var default_filename = filename;
        while(ret.indexOf(filename) >= 0) {
          filename = default_filename + counter.toString();
          counter++;
        }

        /// ディレクトリ作成
        return rpc.files.makeDir(filename);
      }).then((String ret) {
        print('Direcotry $filename is $ret');
        test.expect(ret == filename, test.isTrue);

        /// 作成したディレクトリがディレクトリか
        return rpc.files.isDir(filename);
      }).then((bool ret) {
        test.expect(ret, test.isTrue);

        /// 作成したディレクトリがファイルか
        return rpc.files.isFile(filename);
      }).then((bool ret) {
        test.expect(ret, test.isFalse);

        /// ディレクトリ削除
        return rpc.files.removeDir(filename);
      });

      f.then((String ret) {
        print('Direcotry $filename removed.');
        test.expect(ret == filename, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Test Directory make/remove');
      });

      return f;
    });
  });
}