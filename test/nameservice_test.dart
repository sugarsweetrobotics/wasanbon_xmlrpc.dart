// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test.misc_test;

import 'dart:async';
import 'dart:io';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';


String test_script = '''
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Python -*-

import sys, traceback
import time
import yaml
sys.path.append(".")

# Import RTM module
import RTC
import OpenRTM_aist

test_rtc_spec = ["implementation_id", "TestRTC",
		 "type_name",         "TestRTC",
		 "description",       "RTM Test Component",
		 "version",           "1.0.0",
		 "vendor",            "Sugar Sweet Robotics",
		 "category",          "Test",
		 "activity_type",     "STATIC",
		 "max_instance",      "1",
		 "language",          "Python",
		 "lang_type",         "SCRIPT",

		 "conf.default.debug", "1",

		 "conf.__widget__.debug", "text",

		 ""]

class TestRTC(OpenRTM_aist.DataFlowComponentBase):
  def __init__(self, manager):
    OpenRTM_aist.DataFlowComponentBase.__init__(self, manager)
    self._d_in = RTC.TimedLong(RTC.Time(0,0), 0)
    self._inIn = OpenRTM_aist.InPort("in", self._d_in)
    self._d_out = RTC.TimedLong(RTC.Time(0,0), 0)
    self._outOut = OpenRTM_aist.OutPort("out", self._d_out)
    self._debug = [1]

  def onInitialize(self):
    self.bindParameter("debug", self._debug, "1")
    self.addInPort("in", self._inIn)
    self.addOutPort("out", self._outOut)
    return RTC.RTC_OK
  def onActivated(self, ec_id):
    return RTC.RTC_OK

  def onDeactivated(self, ec_id):
    return RTC.RTC_OK

  def onExecute(self, ec_id):
    return RTC.RTC_OK

def TestRTCInit(manager):
  profile = OpenRTM_aist.Properties(defaults_str=test_rtc_spec)
  manager.registerFactory(profile, TestRTC, OpenRTM_aist.Delete)

def MyModuleInit(manager):
  TestRTCInit(manager)
  # Create a component
  comp = manager.createComponent("TestRTC?naming.formats=%n.rtc")

def main():
  argv = ["TestRTC.py"]
  mgr = OpenRTM_aist.Manager.init(argv)
  mgr.setModuleInitProc(MyModuleInit)
  mgr.activateManager()
  mgr.runManager()

if __name__ == "__main__":
  main()
''';

main() {
  nameservice_test();
}

nameservice_test() {
  test.group('NameService tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
    });

/*
    /// ファイル保存テスト
    test.test('Save File Test', () async {
      var filename = 'test_file_name.txt';
      var content = test_script;

      /// ファイル保存テスト
      test.expect(rpc.files.uploadFile(filename, content).then((String ret) {
        print('Saved File $filename is $ret');
        test.expect(ret == filename, test.isTrue);

        /// ファイル内容確認
        return rpc.files.downloadFile(filename);
      }).then((String ret) {
        /// print('File content is $ret');
        test.expect(ret == content, test.isTrue);

        /// ファイルの除去
        return rpc.files.deleteFile(filename);
      }).then((String ret) {
        print('File remove is $ret');
        test.expect(ret == filename, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Removing file.');
        print(dat);
        test.fail('Exception occured in Test uploadFile');
      }), test.completes);
    });
*/


    /// ファイル保存テスト
    test.test('NameServer and RTC test', () {
      int port = 2809;
      var filename = 'TestRTC.py';
      var content = test_script;

      Future f = rpc.nameService.stop(port).then((Process p) {
        test.expect(p != null, test.isTrue);
        return rpc.files.uploadFile(filename, content);
      }).then((String ret) {
        print('Saved File $filename is $ret');
        test.expect(ret == filename, test.isTrue);

        /// ファイル内容確認
        return rpc.files.downloadFile(filename);
      }).then((String ret) {
        test.expect(ret == content, test.isTrue);

        /// ネームサーバー実行
        return rpc.nameService.start(port);
      }).then((Process p) {
        test.expect(p != null, test.isTrue);

        /// RTC実行
        return rpc.processes.run(filename);
      }).then((Process p) {
        test.expect(p != null, test.isTrue);

        int count = 20;
        for (int i = 0; i < count; i++) {
          print('Waiting for Start and Register RT-component(${count - i}/$count)');
          sleep(const Duration(seconds: 1));
        }
        return rpc.nameService.tree(port: port);
      }).then((NameServerInfo nss) {
        Component rtc = null;
        nss.nameServers.forEach((NameService ns) {
          ns.components.forEach((Component c) {
            if (c.name == 'TestRTC0.rtc') {
              rtc = c;
            }
          });
        });

        test.expect(
            rtc != null, test.isTrue, reason: 'RTC(TestRTC0.rtc) not found');
        return rpc.nameService.activateRTC(rtc.full_path);
      }).then((String msg) {
        int count = 5;
        for (int i = 0; i < count; i++) {
          print('Waiting for Process updated(${count - i}/$count)');
          sleep(const Duration(seconds: 1));
        }

        return rpc.nameService.tree(port: port);
      }).then((NameServerInfo nss) {
        Component rtc = null;
        nss.nameServers.forEach((NameService ns) {
          ns.components.forEach((Component c) {
            if (c.name == 'TestRTC0.rtc') {
              rtc = c;
            }
          });
        });

        test.expect(
            rtc != null, test.isTrue, reason: 'RTC(TestRTC0.rtc) not found');
        test.expect(rtc.state == Component.ACTIVE_STATE, test.isTrue,
            reason: 'RTC(TestRTC0.rtc) not activated');

        return rpc.nameService.deactivateRTC(rtc.full_path);
      }).then((String msg) {
        int count = 5;
        for (int i = 0; i < count; i++) {
          print('Waiting for Process updated(${count - i}/$count)');
          sleep(const Duration(seconds: 1));
        }

        return rpc.nameService.tree(port: port);
      }).then((NameServerInfo nss) {
        Component rtc = null;
        nss.nameServers.forEach((NameService ns) {
          ns.components.forEach((Component c) {
            if (c.name == 'TestRTC0.rtc') {
              rtc = c;
            }
          });
        });

        test.expect(
            rtc != null, test.isTrue, reason: 'RTC(TestRTC0.rtc) not found');
        test.expect(rtc.state == Component.INACTIVE_STATE, test.isTrue,
            reason: 'RTC(TestRTC0.rtc) not inactivated');

        return rpc.nameService.exitRTC(rtc.full_path);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in NameSErver & RTC Test.');
      });


      return f;
    });



    Future _start_and_check_and_stop(int port) {
      var f = rpc.nameService.start(port).then((Process p) {
        test.expect(p != null, test.isTrue);
        return rpc.nameService.checkRunning(port);
      }).then((bool flag) {
        test.expect(flag, test.isTrue);
        return rpc.nameService.stop(port);
      });


      f.then((Process p) {
        test.expect(p != null, test.isTrue);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Stop NameServer test');
      });

      return f;
    }

    /// ネームサーバー起動・停止テスト
    test.test('NameService Test', () {
      int port = 61500;
      Future f = rpc.nameService.stop(port).then((Process p) {
        return _start_and_check_and_stop(port);
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Check Running test');
      });

      return f;
    });
  });
}