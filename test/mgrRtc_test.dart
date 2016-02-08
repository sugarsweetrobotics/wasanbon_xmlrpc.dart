// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.mgrRtc_test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';

import 'package:logging/logging.dart';

main() {
  mgrRtc_test();
}

mgrRtc_test() {

  test.group('RTC tests', ()
  {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.WARNING;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });

    /// リスティングテスト
    test.test('Listing RTCs', () async {
      var packageName;
      Future f = rpc.adminPackage.list().then((List<PackageInfo> pkgs) {
        print('Packages are $pkgs');
        test.expect(pkgs.length > 0, test.isTrue);

        packageName = pkgs[0].name;
        return rpc.mgrRtc.getRtcList(packageName);
      });

      f.then((List<RtcInfo> rtcs) {
        print('RTCs in $packageName are $rtcs');
        test.expect(rtcs.length > 0, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Repository listing test');
      });

      return f;
    });


    /// ビルド・クリーンテスト
    test.test('Build/Clean RTCs', () async {
      var packageName;
      var rtcName;
      var pkgs;
      Future f = rpc.adminPackage.list().then((List<PackageInfo> pkgs_) {
        pkgs = pkgs_;
        print('Packages are $pkgs');
        test.expect(pkgs.length > 0, test.isTrue);

        packageName = pkgs[0].name;
        return rpc.mgrRtc.getRtcList(packageName);
      }).then((List<RtcInfo> rtcs) {
        print('RTCs in $packageName are $rtcs');
        test.expect(pkgs.length > 0, test.isTrue);


        rtcName = rtcs[0].name;
        return rpc.mgrRtc.cleanRTC(packageName, rtcName);
      }).then((var buildInfo) {
        print('RTC $rtcName cleaned.');
        test.expect(buildInfo.success, test.isTrue);

        return rpc.mgrRtc.buildRTC(packageName, rtcName);
      }).then((var buildInfo) {
        print('RTC $rtcName built');
        test.expect(buildInfo.success, test.isTrue);

        print(buildInfo.stdout);
        return rpc.mgrRtc.cleanRTC(packageName, rtcName);
      });

      f.then((BuildInfo info) {
        print('RTC $rtcName cleaned');
        test.expect(info.success, test.isTrue);

      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Build/Clean RTC.');
      });

      return f;
    });
  });
}