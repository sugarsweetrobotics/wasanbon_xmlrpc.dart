// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.admin_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


admin_test() {

  test.group('Admin tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    /// リスティングテスト
    test.test('Listing Repositories', () async {
      test.expect(
          rpc.admin.getPackageRepositoryList().then((List<PackageRepositoryInfo> pkgs) {
            print('Package Repositories are $pkgs');
            test.expect(pkgs.length > 0, test.isTrue);
          }).catchError((dat) {
            test.fail('Exception occured in Repository listing test');
          }), test.completes);
    });

    /// リスティングテスト
    test.test('Listing Packages', () async {
      test.expect(
          rpc.admin.getPackageList().then((List<PackageInfo> pkgs) {
            print('Packages are $pkgs');
            test.expect(pkgs.length > 0, test.isTrue);
          }).catchError((dat) {
            test.fail('Exception occured in Package listing test');
          }), test.completes);
    });

    /// クローンテスト
    test.test('Cloning and Deleting Packages', () async {
      test.expect(
      // 現状のパッケージのリストを取得
          rpc.admin.getPackageList().then((List<PackageInfo> pkgs) {
            //print('Packages are $pkgs');
            test.expect(pkgs.length > 0, test.isTrue);

            // レポジトリのリストを取得
            rpc.admin.getPackageRepositoryList().then((
                List<PackageRepositoryInfo> repos) {
              //print('Package Repositories are $pkgs');
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

              var clone_repository = repos[i];

              // リポジトリをクローン
              rpc.admin.clonePackageRepository(clone_repository.name).then((var ret) {
                print('Cloned repository. Return is $ret');

                // 最新のパッケージのリストを取得
                rpc.admin.getPackageList().then((List<PackageInfo> new_pkgs) {
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

                  var cloned_package = new_pkgs[i];

                  test.expect(
                      cloned_package.name == clone_repository.name, test.isTrue);


                  rpc.admin.deletePackage(cloned_package.name).then((var ret) {
                    print('Deleted package ${cloned_package.name}. ret = $ret');
                  }).catchError((var e) {
                    test.fail('Exception occured in deleting Package ${cloned_package.name}');
                  });
                }).catchError((dat) {
                  test.fail('Exception occured in Package listing test');
                });

              }).catchError((var d) {
                test.fail('Error occured in cloning repository ${repos[i].name}');
              });
            }).catchError((dat) {
              test.fail('Exception occured in Repository listing test');
            });
          }).catchError((dat) {
            test.fail('Exception occured in Package listing test');
          }), test.completes);
    });


  });
}