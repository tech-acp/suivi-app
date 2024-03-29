import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../custom_code/widgets/index.dart' as custom_widgets;
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MapPageWidget extends StatefulWidget {
  const MapPageWidget({
    Key? key,
    this.id,
  }) : super(key: key);

  final String? id;

  @override
  _MapPageWidgetState createState() => _MapPageWidgetState();
}

class _MapPageWidgetState extends State<MapPageWidget>
    with TickerProviderStateMixin {
  LatLng? currentUserLocationValue;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => setState(() => currentUserLocationValue = loc));
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }
    final fireWorksController = AnimationController(vsync: this);
    return StreamBuilder<List<RegistrationsRecord>>(
      stream: queryRegistrationsRecord(
        queryBuilder: (registrationsRecord) =>
            registrationsRecord.where('id', isEqualTo: widget.id),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
            ),
          );
        }
        List<RegistrationsRecord> mapPageRegistrationsRecordList =
            snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final mapPageRegistrationsRecord =
            mapPageRegistrationsRecordList.isNotEmpty
                ? mapPageRegistrationsRecordList.first
                : null;
        return Title(
            title: 'MapPage',
            color: FlutterFlowTheme.of(context).primaryColor,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: SafeArea(
                child: GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(_unfocusNode),
                  child: FutureBuilder<EventsRecord>(
                    future: EventsRecord.getDocumentOnce(
                        mapPageRegistrationsRecord!.event!),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }
                      final columnEventsRecord = snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 1,
                                  child: custom_widgets.SuiviMap(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height * 1,
                                    registration: mapPageRegistrationsRecord!,
                                    currentUserLocation:
                                        currentUserLocationValue,
                                    event: columnEventsRecord,
                                  ),
                                ),
                                if (mapPageRegistrationsRecord!.status! < 2)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 20, 20, 20),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (mapPageRegistrationsRecord!
                                                .status ==
                                            1)
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30,
                                            borderWidth: 1,
                                            buttonSize: 50,
                                            icon: Icon(
                                              Icons.timer_off,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              size: 30,
                                            ),
                                            onPressed: () async {
                                              var confirmDialogResponse =
                                                  await showDialog<bool>(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Abandonner'),
                                                            content: Text(
                                                                'Êtes-vous sûr que vous souhaitez abandonner l\'épreuve ?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        false),
                                                                child: Text(
                                                                    'Annuler'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        true),
                                                                child: Text(
                                                                    'Confirmer'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ) ??
                                                      false;
                                              if (confirmDialogResponse) {
                                                final registrationsUpdateData =
                                                    createRegistrationsRecordData(
                                                  status: 3,
                                                  endTime: getCurrentTimestamp,
                                                );
                                                await mapPageRegistrationsRecord!
                                                    .reference
                                                    .update(
                                                        registrationsUpdateData);
                                              }
                                            },
                                          ),
                                        if (mapPageRegistrationsRecord!
                                                .status ==
                                            0)
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0, -1),
                                            child: FFButtonWidget(
                                              onPressed: !functions.validateStep(
                                                      currentUserLocationValue!,
                                                      columnEventsRecord
                                                          .start.location!)
                                                  ? null
                                                  : () async {
                                                      var confirmDialogResponse =
                                                          await showDialog<
                                                                  bool>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Confirmation'),
                                                                    content: Text(
                                                                        'Vous êtes sur le point de démarrer le suivi de l\'épreuve. Votre temps sera calculé à partir de maintenant.'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            alertDialogContext,
                                                                            false),
                                                                        child: Text(
                                                                            'Annuler'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            alertDialogContext,
                                                                            true),
                                                                        child: Text(
                                                                            'Confirmer'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ) ??
                                                              false;
                                                      if (confirmDialogResponse) {
                                                        final registrationsUpdateData =
                                                            createRegistrationsRecordData(
                                                          startTime:
                                                              getCurrentTimestamp,
                                                          limitTime: functions.getLimitTime(
                                                              columnEventsRecord,
                                                              mapPageRegistrationsRecord!,
                                                              getCurrentTimestamp),
                                                          status: 1,
                                                          currentCheckpoint: -1,
                                                        );
                                                        await mapPageRegistrationsRecord!
                                                            .reference
                                                            .update(
                                                                registrationsUpdateData);
                                                      }
                                                    },
                                              text: 'Démarrer l\'épreuve',
                                              options: FFButtonOptions(
                                                height: 40,
                                                color: Color(0xFF699530),
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .subtitle2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                        ),
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        if (functions.allCheckpointsValidated(
                                                columnEventsRecord.checkpoints!
                                                    .toList(),
                                                mapPageRegistrationsRecord!
                                                    .currentCheckpoint!) &&
                                            (mapPageRegistrationsRecord!
                                                    .status ==
                                                1))
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0, -1),
                                            child: FFButtonWidget(
                                              onPressed: !functions
                                                      .validateNextCheckpoint(
                                                          mapPageRegistrationsRecord!,
                                                          columnEventsRecord,
                                                          currentUserLocationValue!)
                                                  ? null
                                                  : () async {
                                                      final registrationsUpdateData =
                                                          createRegistrationsRecordData(
                                                        endTime:
                                                            getCurrentTimestamp,
                                                        status: 2,
                                                      );
                                                      await mapPageRegistrationsRecord!
                                                          .reference
                                                          .update(
                                                              registrationsUpdateData);
                                                      await fireWorksController
                                                          .forward();
                                                      fireWorksController
                                                          .reset();
                                                    },
                                              text: 'Terminer l\'épreuve',
                                              options: FFButtonOptions(
                                                height: 40,
                                                color: Color(0xFF699530),
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .subtitle2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                        ),
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        if ((mapPageRegistrationsRecord!
                                                    .status ==
                                                1) &&
                                            !functions.allCheckpointsValidated(
                                                columnEventsRecord.checkpoints!
                                                    .toList(),
                                                mapPageRegistrationsRecord!
                                                    .currentCheckpoint!))
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0, -1),
                                            child: FFButtonWidget(
                                              onPressed: !functions
                                                      .validateNextCheckpoint(
                                                          mapPageRegistrationsRecord!,
                                                          columnEventsRecord,
                                                          currentUserLocationValue!)
                                                  ? null
                                                  : () async {
                                                      final registrationsUpdateData =
                                                          {
                                                        'current_checkpoint':
                                                            FieldValue
                                                                .increment(1),
                                                      };
                                                      await mapPageRegistrationsRecord!
                                                          .reference
                                                          .update(
                                                              registrationsUpdateData);
                                                    },
                                              text: 'Valider le checkpoint',
                                              options: FFButtonOptions(
                                                height: 40,
                                                color: Color(0xFF699530),
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .subtitle2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                        ),
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        if (mapPageRegistrationsRecord!
                                                .status ==
                                            1)
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30,
                                            borderWidth: 1,
                                            buttonSize: 40,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryColor,
                                            icon: Icon(
                                              Icons
                                                  .settings_backup_restore_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              size: 20,
                                            ),
                                            onPressed:
                                                mapPageRegistrationsRecord!
                                                            .currentCheckpoint ==
                                                        -1
                                                    ? null
                                                    : () async {
                                                        var confirmDialogResponse =
                                                            await showDialog<
                                                                    bool>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (alertDialogContext) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Annuler le dernier checkpoint'),
                                                                      content: Text(
                                                                          'Êtes-vous sûrs de vouloir annuler le dernier checkpoint ?'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              alertDialogContext,
                                                                              false),
                                                                          child:
                                                                              Text('Annuler'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              alertDialogContext,
                                                                              true),
                                                                          child:
                                                                              Text('Confirmer'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ) ??
                                                                false;
                                                        if (confirmDialogResponse) {
                                                          final registrationsUpdateData =
                                                              {
                                                            'current_checkpoint':
                                                                FieldValue
                                                                    .increment(
                                                                        -(1)),
                                                          };
                                                          await mapPageRegistrationsRecord!
                                                              .reference
                                                              .update(
                                                                  registrationsUpdateData);
                                                        }
                                                      },
                                          ),
                                      ],
                                    ),
                                  ),
                                Align(
                                  alignment: AlignmentDirectional(0, 1),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 10, 40),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: Color(0xFFF1F4F8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (mapPageRegistrationsRecord!
                                                  .status ==
                                              1)
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Prochain Checkpoint :',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 16,
                                                                ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.location_city,
                                                            color: Colors.black,
                                                            size: 24,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              functions
                                                                  .getNextCheckpoint(
                                                                      mapPageRegistrationsRecord!,
                                                                      columnEventsRecord)
                                                                  .city!,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (columnEventsRecord
                                                              .type ==
                                                          'FF')
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.black,
                                                              size: 24,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                functions
                                                                    .getDistanceBetweenCheckpoints(
                                                                        currentUserLocationValue!,
                                                                        functions
                                                                            .getNextCheckpoint(mapPageRegistrationsRecord!,
                                                                                columnEventsRecord)
                                                                            .location!)
                                                                    .toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1,
                                                              ),
                                                            ),
                                                            Text(
                                                              'km',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1,
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Arrivée',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 16,
                                                                ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            color: Colors.black,
                                                            size: 24,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              functions.getRemainingTime(
                                                                  mapPageRegistrationsRecord!
                                                                      .limitTime!),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (columnEventsRecord
                                                              .type ==
                                                          'FF')
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.black,
                                                              size: 24,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                functions
                                                                    .getDistanceBetweenCheckpoints(
                                                                        currentUserLocationValue!,
                                                                        columnEventsRecord
                                                                            .finish
                                                                            .location!)
                                                                    .toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1,
                                                              ),
                                                            ),
                                                            Text(
                                                              'km',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1,
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (mapPageRegistrationsRecord!
                                                  .status ==
                                              2)
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Épreuve terminée !',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 16,
                                                                ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            color: Colors.black,
                                                            size: 24,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              functions
                                                                  .getTotalTime(
                                                                      mapPageRegistrationsRecord!),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.speed,
                                                            color: Colors.black,
                                                            size: 24,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              '${functions.getAverageSpeed(mapPageRegistrationsRecord!, columnEventsRecord).toString()} km/h',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (mapPageRegistrationsRecord!
                                                  .status ==
                                              3)
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Épreuve abandonnée.',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 16,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Lottie.network(
                                    'https://assets10.lottiefiles.com/packages/lf20_jEMHbp.json',
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    fit: BoxFit.cover,
                                    controller: fireWorksController,
                                    onLoaded: (composition) =>
                                        fireWorksController.duration =
                                            composition.duration,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }
}
