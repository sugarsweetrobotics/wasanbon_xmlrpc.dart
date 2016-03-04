
library wasanbon_xmlrpc.test.wsconverter_test;

import 'dart:async';
import 'dart:io' as io;
import 'package:unittest/unittest.dart' as test;
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart';

import 'package:logging/logging.dart';

main() {
  wsconverter_test();
}

wsconverter_test() {
  test.group('WSConverter tests', () {
    WasanbonRPC rpc;

    test.setUp(() async {
      rpc = new WasanbonRPC(url: "http://localhost:8000/RPC");
      Logger.root.level = Level.WARNING;
      rpc.onRecordListen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    });



    test.test('Start /Stop Test', () async {
      var completer = new Completer();
      var port =  8080;
      Future f = rpc.wsconverter.start(port);
      f.then( (var msg) {
        print('msg is $msg');
        test.expect(msg != null, test.isTrue);

        int count = 10;
        for (int i = 0; i < count; i++) {
          print('Waiting for Running system. (${count - i}/$count)');
          io.sleep(const Duration(seconds: 1));
        }
        return rpc.wsconverter.stop();
      }).catchError((dat) {
        print(dat);
        test.fail('Exception occured in Echo test');
      });
      return f;
    });

  });
}