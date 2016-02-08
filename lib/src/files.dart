
library wasanbon_xmlrpc.files;
import "base.dart";
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class FilesFunction extends WasanbonRPCBase {

  FilesFunction(
      {String url: 'http://localhost:8000/RPC', http.Client client: null})
      : super(url: url, client: client) {

  }

  /// List passed directory's children.
  /// returns List<String> if succeeded.
  /// if null, failed.
  Future<List<String>> listDirectory(String dir) {
    logger.fine('${this.runtimeType}.listDirectory($dir)');
    var completer = new Completer();
    rpc('files_list_directory', [dir]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


  /// Print Working Direcotry
  /// returns String : path of working directory
  /// if null failed.
  Future<String> printWorkingDirectory() {
    logger.fine('${this.runtimeType}.printWorkingDirectory()');
    var completer = new Completer();
    rpc('files_print_working_directory', []).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


  /// Change directory to dir
  /// param dir string: destination dir
  /// return String : path of changed directory
  /// if null failed.
  Future<String> changeDirectory(String dir) {
    logger.fine('${this.runtimeType}.changeDirectory($dir)');
    var completer = new Completer();
    rpc('files_change_directory', [dir]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  /// Upload File
  /// filename : path of file
  /// fileContent : text of the file
  /// return string fullpath of the file, null if failed.
  Future<String> uploadFile(String filename, String fileContent) {
    logger.fine('${this.runtimeType}.uploadFile($filename, $fileContent)');
    var completer = new Completer();
    rpc('files_upload_file', [filename, fileContent]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> downloadFile(String filename) {
    logger.fine('${this.runtimeType}.downloadFile($filename)');
    var completer = new Completer();
    rpc('files_download_file', [filename]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> deleteFile(String filename) {
    logger.fine('${this.runtimeType}.deleteFile($filename)');
    var completer = new Completer();
    rpc('files_delete_file', [filename]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> copyFile(String src, String dst) {
    logger.fine('${this.runtimeType}.copyFile($src, $dst)');
    var completer = new Completer();
    rpc('files_copy_file', [src, dst]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


  Future<String> renameFile(String src, String dst) {
    logger.fine('${this.runtimeType}.renameFile($src, $dst)');
    var completer = new Completer();
    rpc('files_rename_file', [src, dst]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<String> makeDir(String path) {
    logger.fine('${this.runtimeType}.makeDir($path)');
    var completer = new Completer();
    rpc('files_make_dir', [path]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<bool> isDir(String path) {
    logger.fine('${this.runtimeType}.isDir($path)');
    var completer = new Completer();
    rpc('files_is_dir', [path]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<bool> isFile(String path) {
    logger.fine('${this.runtimeType}.isFile($path)');
    var completer = new Completer();
    rpc('files_is_file', [path]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }


  Future<String> removeDir(String path, {recursive: false}) {
    logger.fine('${this.runtimeType}.removeDir($path, recursive: $recursive)');
    var completer = new Completer();
    rpc('files_remove_dir', [path, recursive]).then((result) {
      logger.finer(' - $result');
      if (result[0]) completer.complete(result[2]);
      else completer.complete(null);
    }).catchError((error) {
      logger.severe(' - $error');
      completer.completeError(error);
    });
    return completer.future;
  }

}