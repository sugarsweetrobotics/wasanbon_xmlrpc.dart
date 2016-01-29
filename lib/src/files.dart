
library wasanbon_xmlrpc.files;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;

class FilesFunction extends WasanbonRPCBase {

  FilesFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  Future<String> printWorkingDirectory() {
    var completer = new Completer();
    rpc('files_print_working_directory', []).then((result) {
      completer.complete(result[1].toString());
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<String> listDirectory(String dir) {
    var completer = new Completer();
    rpc('files_list_directory', [dir]).then((result) {
      print('files_list_directory results ${result.toString()}');
      completer.complete(result[1]);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<String> changeDirectory(String dir) {
    var completer = new Completer();
    rpc('files_change_directory', [dir]).then((result) {
      completer.complete(result[1]);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<bool> uploadFile(String filename, String fileContent) {
    var completer = new Completer();
    rpc('files_upload_file', [filename, fileContent]).then((result) {
      completer.complete(result[0]);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<bool> downloadFile(String filename) {
    var completer = new Completer();
    rpc('files_download_file', [filename]).then((result) {
      completer.complete(result[1]);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<bool> deleteFile(String filename) {
    var completer = new Completer();
    rpc('files_delete_file', [filename]).then((result) {
      completer.complete(result[0]);
    }).catchError((error) => completer.completeError(error));
    return completer.future;
  }

}