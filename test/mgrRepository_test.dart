// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.rtc_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


main() {
  mgrRtc_test();
}

mgrRtc_test() {
  test.group('RTC Repository tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    /// リスティングテスト
    test.test('Listing RTC Reposiotry', () async {
      var packageName;
      Future f = rpc.admin.getPackageList().then((List<PackageInfo> pkgs) {
        print('Packages are $pkgs');
        test.expect(pkgs.length > 0, test.isTrue);

        packageName = pkgs[0].name;
        return rpc.mgrRepository.list(packageName);
      });

      f.then((List<RtcRepositoryInfo> rtcs) {
        print('RTCs in $packageName are $rtcs');
        test.expect(rtcs.length > 0, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Repository listing test');
      });

      return f;
    });

    /// クローンテスト
    test.test('Cloning RTC Reposiotry', () async {
      var packageName;
      var rtcRepoName = 'TestIn_cpp';
      Future f = rpc.admin.getPackageList().then((List<PackageInfo> pkgs) {
        print('Packages are $pkgs');
        test.expect(pkgs.length > 0, test.isTrue);

        packageName = pkgs[0].name;
        return rpc.mgrRepository.list(packageName);
      }).then((List<RtcRepositoryInfo> rtcs) {
        print('RTCs in $packageName are $rtcs');
        test.expect(rtcs.length > 0, test.isTrue);

        //rtcRepoName = rtcs[0].name;
        return rpc.mgrRepository.clone(packageName, rtcRepoName);
      }).then((String msg) {
        print('RTC $rtcRepoName in $packageName is cloned');
        test.expect(msg != null, test.isTrue);

        /// RTCをリストする
        return rpc.mgrRtc.getRtcList(packageName);
      }).then((List<RtcInfo> rtcs) {
        print('RTCs in $packageName are $rtcs');
        test.expect(rtcs.length > 0, test.isTrue);

        var found = false;
        rtcs.forEach((RtcInfo rtc) {
          if (rtc.name == rtcRepoName) {
            found = true;
          }
        });
        test.expect(found, test.isTrue);

        return rpc.mgrRtc.deleteRTC(packageName, rtcRepoName);
      }).then((String msg) {
        print('RTC $rtcRepoName in $packageName is cloned');
        test.expect(msg != null, test.isTrue);

        /// RTCをリストする
        return rpc.mgrRtc.getRtcList(packageName);
      });

      f.then((List<RtcInfo> rtcs) {
        print('RTCs in $packageName are $rtcs');
        test.expect(rtcs.length > 0, test.isTrue);

        var found = false;
        rtcs.forEach((RtcInfo rtc) {
          if (rtc.name == rtcRepoName) {
            found = true;
          }
        });
        test.expect(found, test.isFalse);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Repository listing test');
      });

      return f;
    });


  });
}