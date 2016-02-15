// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.adminRepository_test;

import 'dart:async';
import 'dart:io' as io;
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';
import 'package:logging/logging.dart';

main() {
  mgrSystem_test();
}

mgrSystem_test() {



  test.group('mgrSystem tests', ()
  {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.WARNING;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });


    /// クローンテスト
    test.test('Cloning and Run/Terminate and Deleting Packages', () async {
      var pkgs;
      var repo_names = ['test_project01', 'test_project02', 'test_project03'];
      var clone_repository = '';
      PackageInfo cloned_package;
      // 現状のパッケージのリストを取得
      Future f = rpc.adminPackage.list().then((List<PackageInfo> pkgs_) {
        print('Packages are $pkgs_');
        pkgs = pkgs_;
        test.expect(pkgs.length > 0, test.isTrue);

        // レポジトリのリストを取得
        return rpc.adminRepository.list();
      }).then((List<PackageRepositoryInfo> repos) {
        test.expect(repos.length > 0, test.isTrue);

        includes(String repo) {
          bool ret = false;
          pkgs.forEach((PackageInfo pkg) {
            if (repo == pkg.name) {
              ret = true;
            }
          });
          return ret;
        }

        /// テストするリポジトリを選定する
        int i = 0;
        for (i = 0; i < repo_names.length; i++) {
          if (!includes(repo_names[i])) {
            break;
          }
        }

        clone_repository = repo_names[i];

        print('## Cloning Package $clone_repository');
        // リポジトリをクローン
        return rpc.adminRepository.clone(clone_repository);
      }).then((var ret) {
        print('Cloned repository. Return is $ret');

        // 最新のパッケージのリストを取得
        return rpc.adminPackage.list();
      }).then((List<PackageInfo> new_pkgs) {
        //print('Packages are $pkgs');
        test.expect(new_pkgs.length > 0, test.isTrue);

        int i = 0;
        for (i = 0; i < new_pkgs.length; i++) {
          bool found = false;
          pkgs.forEach((PackageInfo pkg) {
            if (pkg.name == new_pkgs[i].name) {
              found = true;
            }
          });
          if (!found) {
            break;
          }
        }

        cloned_package = new_pkgs[i];

        test.expect(
            cloned_package.name == clone_repository, test.isTrue);


        // パッケージをビルド
        return rpc.mgrRtc.buildRTC(cloned_package.name, 'all');
      }).then((BuildInfo info) {
        test.expect(info.success, test.isTrue);

        return rpc.nameService.stop(2809);
      }).then((var e) {
        return rpc.nameService.start(2809);
      }).then((Process p) {

        /// パッケージの実行
        return rpc.mgrSystem.run(
            cloned_package.name, cloned_package.defaultSystem);
      }).then((bool flag) {
        int count = 10;
        for (int i = 0; i < count; i++) {
          print('Waiting for Running system. (${count - i}/$count)');
          io.sleep(const Duration(seconds: 1));
        }

        return rpc.files.changeDirectory(cloned_package.path);
      }).then((String path) {
        return rpc.files.downloadFile('testout.txt');
      }).then((String content) {

        print('Content is $content');
        content.trim();
        test.expect(content.indexOf('1') >= 0, test.isTrue);
        /// パッケージの停止
        return rpc.mgrSystem.terminate(cloned_package.name);
      }).then((bool flag) {

        /// パッケージを削除
        return rpc.adminPackage.delete(cloned_package.name);
      });

      f.then((var ret) {
        print('Deleted package ${cloned_package.name}. ret = $ret');
      }).catchError((var e) {
        print(e);
        test.fail(
            'Exception occured in Package Clone Test');
      });

      return f;
    });
  });

}