import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// File-system boundary for backup files, kept behind an interface so widget
/// tests never need platform plugins.
abstract class BackupFileService {
  Future<void> shareBackup({
    required String json,
    required String fileName,
    required String subject,
  });

  /// Returns the file contents, or null when the user cancels the picker.
  Future<String?> pickBackupJson();
}

class PlatformBackupFileService implements BackupFileService {
  @override
  Future<void> shareBackup({
    required String json,
    required String fileName,
    required String subject,
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File(p.join(directory.path, fileName));
    await file.writeAsString(json, flush: true);

    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[
          XFile(file.path, mimeType: 'application/json', name: fileName),
        ],
        fileNameOverrides: <String>[fileName],
        subject: subject,
        title: subject,
      ),
    );
  }

  @override
  Future<String?> pickBackupJson() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: <String>['json'],
    );
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    return utf8.decode(bytes);
  }
}
