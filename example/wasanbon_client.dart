// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon.example;

import 'package:wasanbon_xmlrpc/wasanbon_xmlrpc.dart' as wasanbon;
import 'package:xml/xml.dart' as xml;
main() {
  var rpc = new wasanbon.WasanbonRPC(url: "http://localhost:8000/RPC");
  rpc.getVersionInfo()
  .then((info) => print(info.version))
  .catchError((dat) => print(dat));
  
  rpc.getPackageInfos()
  .then((infos) { 
    print('--- package');
    for(wasanbon.PackageInfo info in infos) {
      print ('pkg : ' + info.name);
    }
  })
  .catchError((res) { 
    print(res);
  });
  
  rpc.getRtcInfos('ardrone_test')
  .then((infos) { 
    print('--- rtc');
    for(wasanbon.RtcInfo info in infos) {
      print ('rtc : ' + info.name);
    }
  })
  .catchError((res) { 
      print(res);
  });
  
  rpc.getSystemInfos('ardrone_test')
  .then((infos) { 
    print('--- system');
    for(wasanbon.SystemInfo info in infos) {
      print ('system : ' + info.name);
    }
  })
  .catchError((res) { 
    print(res);
  });
  
  rpc.getRTCProfile('nao_test', 'NAO')
  .then((xml.XmlDocument info) { 
    print('--- rtcprof');
    var elems = info.findAllElements('BasicInfo', namespace: 'http://www.openrtp.org/namespaces/rtc');
    print(elems);
  })
  .catchError((res) { 
    print(res);
  });
  
  rpc.startNameService(2809)
  .then((retval) { 
    print('--NamServer ${retval}');
    
  })
  .catchError((res) { 
    print(res);
  });
  
  rpc.stopNameService(2809)
  .then((retval) { 
    print('--NamServer ${retval}');
    
  })
  .catchError((res) { 
    print(res);
  });
}
