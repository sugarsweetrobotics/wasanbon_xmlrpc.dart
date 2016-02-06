// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.admin_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


main() {
  admin_test();
}

admin_test() {

  test.group('Admin tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    /// リスティングテスト
    test.test('Listing Repositories', () async {
      Future f = rpc.admin.getPackageRepositoryList();

      f.then((List<PackageRepositoryInfo> pkgs) {
        print('Package Repositories are $pkgs');
        test.expect(pkgs.length > 0, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Repository listing test');
      });

      return f;
    });

    /// リスティングテスト
    test.test('Listing Packages', () async {
      Future f = rpc.admin.getPackageList();

      f.then((List<PackageInfo> pkgs) {
        print('Packages are $pkgs');
        test.expect(pkgs.length > 0, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Package listing test');
      });

      return f;
    });

    /// クローンテスト
    test.test('Cloning and Deleting Packages', () async {
      var pkgs;
      var clone_repository;
      var cloned_package;
      // 現状のパッケージのリストを取得
      Future f = rpc.admin.getPackageList().then((List<PackageInfo> pkgs_) {
        print('Packages are $pkgs');
        pkgs = pkgs_;
        test.expect(pkgs.length > 0, test.isTrue);

        // レポジトリのリストを取得
        return rpc.admin.getPackageRepositoryList();
      }).then((List<PackageRepositoryInfo> repos) {
        test.expect(repos.length > 0, test.isTrue);

        includes(PackageRepositoryInfo repo) {
          bool ret = false;
          pkgs.forEach((PackageInfo pkg) {
            if (repo.name == pkg.name) {
              ret = true;
            }
          });
          return ret;
        }

        /// テストするリポジトリを選定する
        int i = 0;
        for (i = 0; i < repos.length; i++) {
          if (!includes(repos[i])) {
            break;
          }
        }

        clone_repository = repos[i];

        print ('## Cloning Package $clone_repository');
        // リポジトリをクローン
        return rpc.admin.clonePackageRepository(clone_repository.name);
      }).then((var ret) {
        print('Cloned repository. Return is $ret');

        // 最新のパッケージのリストを取得
        return rpc.admin.getPackageList();
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
            cloned_package.name == clone_repository.name, test.isTrue);


        return rpc.admin.deletePackage(cloned_package.name);
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