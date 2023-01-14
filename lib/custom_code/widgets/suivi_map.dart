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

class SuiviMap extends StatefulWidget {
  const SuiviMap({
    Key? key,
    this.width,
    this.height,
    required this.registration,
    required this.currentUserLocation,
    required this.event,
  }) : super(key: key);

  final double? width;
  final double? height;
  final RegistrationsRecord registration;
  final LatLng? currentUserLocation;
  final EventsRecord event;

  @override
  _SuiviMap createState() => _SuiviMap();
}

class _SuiviMap extends State<SuiviMap> with TickerProviderStateMixin {
  late final MapController mapController;
  LatLngBounds bounds = LatLngBounds();

  @override
  void initState() {
    super.initState();
    bounds = LatLngBounds.fromPoints(widget.event.checkpoints!
        .map((checkpoint) => latlon.LatLng(
            checkpoint.location!.latitude, checkpoint.location!.longitude))
        .toList()
      ..add(latlon.LatLng(widget.event.start.location!.latitude,
          widget.event.start.location!.longitude))
      ..add(latlon.LatLng(widget.event.finish.location!.latitude,
          widget.event.finish.location!.longitude)));

    mapController = MapController();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          latlon.LatLng(
              latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          bounds: bounds,
          boundsOptions: FitBoundsOptions(
            padding:
                EdgeInsets.only(left: 50, right: 50, top: 100, bottom: 300),
          ),
          interactiveFlags: InteractiveFlag.doubleTapZoom |
              InteractiveFlag.drag |
              InteractiveFlag.pinchMove |
              InteractiveFlag.pinchZoom),
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
        PolylineLayer(
          polylineCulling: false,
          polylines: [
            Polyline(
              points: widget.event.checkpoints!
                  .map((checkpoint) => latlon.LatLng(
                      checkpoint.location!.latitude,
                      checkpoint.location!.longitude))
                  .toList()
                ..insert(
                    0,
                    latlon.LatLng(widget.event.start.location!.latitude,
                        widget.event.start.location!.longitude))
                ..add(latlon.LatLng(widget.event.finish.location!.latitude,
                    widget.event.finish.location!.longitude)),
              color: widget.registration.status! != 2
                  ? Color.fromARGB(255, 61, 33, 243)
                  : Colors.lightGreen,
              strokeWidth: widget.registration.status! != 2 ? 2 : 4,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: latlon.LatLng(widget.event.start.location!.latitude,
                  widget.event.start.location!.longitude),
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
            Marker(
              point: latlon.LatLng(widget.event.finish.location!.latitude,
                  widget.event.finish.location!.longitude),
              anchorPos: AnchorPos.align(AnchorAlign.center),
              width: 25,
              height: 25,
              builder: (context) => Container(
                //key: Key('blue'),
                child: Icon(
                  Icons.circle,
                  color: Colors.lightGreen,
                  size: 25,
                ),
              ),
            ),
            ...widget.event.checkpoints!.map((checkpoint) => Marker(
                  point: latlon.LatLng(checkpoint.location!.latitude,
                      checkpoint.location!.longitude),
                  anchorPos: AnchorPos.align(AnchorAlign.center),
                  width: 25,
                  height: 25,
                  builder: (context) => Container(
                    //key: Key('blue'),
                    child: CircleAvatar(
                      backgroundColor:
                          (widget.event.checkpoints!.indexOf(checkpoint) <=
                                  widget.registration.currentCheckpoint!)
                              ? Colors.lightGreen
                              : Colors.black,
                      child: Center(
                        child: Text(
                          (widget.event.checkpoints!.indexOf(checkpoint) + 1)
                              .toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )),
            Marker(
              point: latlon.LatLng(widget.currentUserLocation!.latitude,
                  widget.currentUserLocation!.longitude),
              anchorPos: AnchorPos.align(AnchorAlign.center),
              width: 30,
              height: 30,
              builder: (context) => Container(
                //key: Key('blue'),
                child: Icon(
                  Icons.my_location,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
