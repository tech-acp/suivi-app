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

import 'package:http/http.dart' as http;
import 'package:gpx/gpx.dart';

Future<List<LatLng>> getGpxPoints(String gpx_url) async {
  // Add your function code here!

  Map<String, String> headers = {"Accept": "text/html,application/xml"};
  final response = await http.get(Uri.parse(gpx_url), headers: headers);

  final Gpx xmlGpx = GpxReader().fromString(response.body);

  return xmlGpx.trks.first.trksegs.first.trkpts
      .map((e) => LatLng(e.lat!, e.lon!))
      .toList();
}
