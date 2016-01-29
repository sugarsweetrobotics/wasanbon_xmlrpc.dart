// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test;

import 'dart:async';
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart' as wasanbon;

main() {
  test.group('Echo tests', () {
    wasanbon.WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    test.test('Echo Test', () async {
      var yahoo = 'Hello';
      Future f = rpc.misc.echo(yahoo).then( (var msg) {
        print('msg is $msg');
        //test.expect(yahoo == msg, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Echo test');
        //print(dat);
      });
      test.expect(f, test.completes);
    });
  });

  test.group('Processes', () {
    wasanbon.WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");
    });

    test.test('Save file test', () async {
      var filename = 'test_file_name.py';
      var content = 'print "Hello World. This is Python script"';
      test.expect(rpc.files.uploadFile(filename, content).then((var ret) {
        print('Saved File $filename is $ret');
        test.expect(ret, test.isTrue);

        test.expect(rpc.files.downloadFile(filename).then((var ret) {
          print('File content is $ret');
          test.expect(ret == content, test.isTrue);

          test.expect(rpc.processes.run(filename).then((var ret) {
            print('Process Run is $ret');
            test.expect(ret, test.isTrue);


          }).catchError((dat) {
            test.fail('Exception occured in processes_run ');
            print(dat);
          }), test.completes);

        }).catchError((dat) {
          test.fail('Exception occured in content verification.');
          print(dat);
        }), test.completes);

      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      }), test.completes);



      /*
      test.expect(rpc.files.deleteFile(filename).then((var ret) {
        print('File remove is $ret');
        test.expect(ret, test.isTrue);
      }).catchError((dat) {
        test.fail('Exception occured in Test');
        print(dat);
      }), test.completes);
      */
    });
  });


  test.group('Files Tests', () {
    wasanbon.WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");
    });

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
      test.expect(rpc.files.uploadFile(filename, content).then((var ret) {
        print('Saved File $filename is $ret');
        test.expect(ret, test.isTrue);


        test.expect(rpc.files.downloadFile(filename).then((var ret) {
          print('File content is $ret');
          test.expect(ret == content, test.isTrue);

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
