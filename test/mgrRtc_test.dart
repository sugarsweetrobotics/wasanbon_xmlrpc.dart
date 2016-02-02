// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.rtc_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


main() {
  mgrRtc_test();
}

mgrRtc_test() {

  test.group('RTC tests', ()
  {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    /// リスティングテスト
    test.test('Listing RTCs', () async {
      test.expect(
        rpc.admin.getPackageList().then((List<PackageInfo> pkgs) {
          print('Packages are $pkgs');
          test.expect(pkgs.length > 0, test.isTrue);

          var packageName = pkgs[0].name;
          rpc.mgrRtc.getRtcList(packageName).then((List<RtcInfo> rtcs) {
            print('RTCs in $packageName are $rtcs');
            test.expect(pkgs.length > 0, test.isTrue);
          }).catchError((dat) {
            test.fail('Exception occured in Repository listing test');
          });
        }).catchError((dat) {
          test.fail('Exception occured in Repository listing test');
        }), test.completes);
    });


    /// ビルド・クリーンテスト
    test.test('Build/Clean RTCs', () async {
      test.expect(
          rpc.admin.getPackageList().then((List<PackageInfo> pkgs) {
            print('Packages are $pkgs');
            test.expect(pkgs.length > 0, test.isTrue);

            var packageName = pkgs[0].name;
            rpc.mgrRtc.getRtcList(packageName).then((List<RtcInfo> rtcs) {
              print('RTCs in $packageName are $rtcs');
              test.expect(pkgs.length > 0, test.isTrue);


              var rtcName = rtcs[0].name;
              rpc.mgrRtc.cleanRTC(packageName, rtcName).then((var buildInfo) {
                print('RTC $rtcName cleaned.');
                test.expect(buildInfo.success, test.isTrue);

                rpc.mgrRtc.buildRTC(packageName, rtcName).then((var buildInfo) {
                  print('RTC $rtcName built');
                  test.expect(buildInfo.success, test.isTrue);
                }).catchError((var e) {
                  test.fail('Exception occured in building RTC ($packageName.$rtcName)');
                });

              }).catchError((var e) {
                test.fail('Exception occured in cleaning RTC ($packageName.$rtcName)');
              });
            }).catchError((dat) {
              test.fail('Exception occured in Listing RTC in $packageName');
            });
          }).catchError((dat) {
            test.fail('Exception occured in Package Listing');
          }), test.completes);
    });


  });
}