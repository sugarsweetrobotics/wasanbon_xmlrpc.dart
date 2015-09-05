// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon.example;

import 'dart:async';
import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart' as wasanbon;
import 'package:xml/xml.dart' as xml;

main() {
  var rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");
  var pack = "simvehicle";
  var rtc = "MobileRobot";
  Future.wait([rpc.rtc.buildRTC(pack, rtc)])
  .then((infoList) => print(infoList[0]))
  .catchError((dat) => print(dat));

  rpc.rtc.cleanRTC(pack, rtc)
  .then((info) => print(info))
  .catchError((dat) => print(dat));
}