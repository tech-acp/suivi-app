import '../backend/supabase/supabase.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventCardWidget extends StatefulWidget {
  const EventCardWidget({
    Key? key,
    this.brevet,
  }) : super(key: key);

  final BrevetsRow? brevet;

  @override
  _EventCardWidgetState createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFFF5F5F5),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              valueOrDefault<String>(
                widget.brevet?.date,
                'toto',
              ),
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
            Text(
              valueOrDefault<String>(
                widget.brevet?.distance?.toString(),
                '0',
              ),
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
