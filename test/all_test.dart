// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library wasanbon_xmlrpc.test;

import 'files_test.dart';
import 'mgrRtc_test.dart';
import 'processes_test.dart';
import 'adminPackage_test.dart';
import 'misc_test.dart';
import 'nameservice_test.dart';

main() {
  misc_test();
  admin_test();
  processes_test();
  files_test();
  mgrRtc_test();
  nameservice_test();
}
