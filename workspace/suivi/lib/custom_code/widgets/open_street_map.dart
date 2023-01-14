// Automatic FlutterFlow imports
import '../../backend/backend.dart';
import '../../backend/supabase/supabase.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlon;

class OpenStreetMap extends StatefulWidget {
  const OpenStreetMap({
    Key? key,
    this.width,
    this.height,
    required this.event,
    required this.startLocation,
  }) : super(key: key);

  final double? width;
  final double? height;
  final EventsRecord event;
  final LatLng startLocation;

  @override
  _OpenStreetMapState createState() => _OpenStreetMapState();
}

class _OpenStreetMapState extends State<OpenStreetMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        center: latlon.LatLng(46.227638, 2.213749),
        zoom: 6,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: [
        TileLayer(
          urlTemplate:
              'https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=c039ca3093f842ac8ffd0039ad22226c',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: latlon.LatLng(widget.startLocation.latitude,
                  widget.startLocation.longitude),
              anchorPos: AnchorPos.align(AnchorAlign.center),
              width: 25,
              height: 25,
              builder: (context) => Container(
                //key: Key('blue'),
                child: Icon(
                  Icons.circle,
                  color: Colors.lightBlue,
                  size: 25,
                ),
              ),
            ),
            ...widget.event.checkpoints!
                .map((checkpoint) => Marker(
                      point: latlon.LatLng(checkpoint.location!.latitude,
                          checkpoint.location!.longitude),
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      width: 25,
                      height: 25,
                      builder: (context) => Container(
                        //key: Key('blue'),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Center(
                            child: Text(
                              (widget.event.checkpoints!.indexOf(checkpoint) +
                                      1)
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList()
          ],
        ),
      ],
    );
  }
}
