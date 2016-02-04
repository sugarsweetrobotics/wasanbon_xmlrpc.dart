
library wasanbon_xmlrpc.files;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;

class FilesFunction extends WasanbonRPCBase {

  FilesFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  /// List passed directory's children.
  /// returns List<String> if succeeded.
  /// if null, failed.
  Future<List<String>> listDirectory(String dir) {
    print('${this.runtimeType}.listDirectory($dir)');
    var completer = new Completer();
    rpc('files_list_directory', [dir]).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


  /// Print Working Direcotry
  /// returns String : path of working directory
  /// if null failed.
  Future<String> printWorkingDirectory() {
    print('${this.runtimeType}.printWorkingDirectory()');
    var completer = new Completer();
    rpc('files_print_working_directory', []).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


  /// Change directory to dir
  /// param dir string: destination dir
  /// return String : path of changed directory
  /// if null failed.
  Future<String> changeDirectory(String dir) {
    print('${this.runtimeType}.changeDirectory($dir)');
    var completer = new Completer();
    rpc('files_change_directory', [dir]).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  /// Upload File
  /// filename : path of file
  /// fileContent : text of the file
  /// return string fullpath of the file, null if failed.
  Future<String> uploadFile(String filename, String fileContent) {
    print('${this.runtimeType}.uploadFile($filename, $fileContent)');
    var completer = new Completer();
    rpc('files_upload_file', [filename, fileContent]).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> downloadFile(String filename) {
    print('${this.runtimeType}.downloadFile($filename)');
    var completer = new Completer();
    rpc('files_download_file', [filename]).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> deleteFile(String filename) {
    print('${this.runtimeType}.deleteFile($filename)');
    var completer = new Completer();
    rpc('files_delete_file', [filename]).then((result) {
      print(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      print(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

}