import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flet/flet.dart';

class PaperNestFilePickerFile {
  final int id;
  final String name;
  final String? path;
  final int size;
  final Uint8List? bytes;

  PaperNestFilePickerFile({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.bytes,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'path': path,
        'size': size,
        'bytes': bytes,
      };
}

class PaperNestFilePickerUploadFile {
  final int? id;
  final String? name;
  final String uploadUrl;
  final String method;

  PaperNestFilePickerUploadFile({
    required this.id,
    required this.name,
    required this.uploadUrl,
    required this.method,
  });
}

class PaperNestFilePickerUploadProgressEvent {
  final String name;
  final double? progress;
  final String? error;

  PaperNestFilePickerUploadProgressEvent({
    required this.name,
    required this.progress,
    required this.error,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'file_name': name,
        'progress': progress,
        'error': error,
      };
}

FileType? parsePaperNestFileType(String? value, [FileType? defaultValue]) {
  return parseEnum(FileType.values, value, defaultValue);
}

extension PaperNestFilePickerParsers on Control {
  FileType? getPaperNestFileType(
    String propertyName, [
    FileType? defaultValue,
  ]) {
    return parsePaperNestFileType(get(propertyName), defaultValue);
  }
}
