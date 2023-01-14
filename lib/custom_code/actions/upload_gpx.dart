// Automatic FlutterFlow imports
import '../../backend/backend.dart';
import '../../backend/supabase/supabase.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '../../flutter_flow/upload_media.dart';
import '../../backend/supabase/storage/storage.dart';

Future<String?> uploadGpx(
  BuildContext context,
  String storagePath,
) async {
  final selectedFile = await selectFile(
      storageFolderPath: storagePath, allowedExtensions: ['gpx']);
  if (selectedFile != null) {
    String? downloadUrl;
    downloadUrl = await uploadSupabaseStorageFile(
      bucketName: 'tracks',
      selectedMedia: selectedFile,
    );

    if (downloadUrl != null) {
      showUploadMessage(
        context,
        'Success!',
      );
      return downloadUrl;
    } else {
      showUploadMessage(
        context,
        'Failed to upload file',
      );
      return null;
    }
  }
}
