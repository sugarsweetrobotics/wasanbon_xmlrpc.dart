// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.admin_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';
import 'package:logging/logging.dart';

main() {
  admin_test();
}

admin_test() {

  test.group('Admin Repository tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.FINE;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });

    /// リスティングテスト
    test.test('Listing Repositories', () async {
      Future f = rpc.adminRepository.list();

      f.then((List<PackageRepositoryInfo> pkgs) {
        print('Package Repositories are $pkgs');
        test.expect(pkgs.length > 0, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Repository listing test');
      });

      return f;
    });


    /// クローンテスト
    test.test('Cloning and Deleting Packages', () async {
      var pkgs;
      var repo_names = ['test_project01', 'test_project02', 'test_project03'];
      var clone_repository = '';
      var cloned_package;
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

        print ('## Cloning Package $clone_repository');
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