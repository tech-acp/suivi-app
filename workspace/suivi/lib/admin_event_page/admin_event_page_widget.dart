import '../backend/api_requests/api_calls.dart';
import '../backend/backend.dart';
import '../backend/supabase/supabase.dart';
import '../components/event_card_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/upload_media.dart';
import '../custom_code/widgets/index.dart' as custom_widgets;
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminEventPageWidget extends StatefulWidget {
  const AdminEventPageWidget({
    Key? key,
    this.brevet,
  }) : super(key: key);

  final BrevetsRow? brevet;

  @override
  _AdminEventPageWidgetState createState() => _AdminEventPageWidgetState();
}

class _AdminEventPageWidgetState extends State<AdminEventPageWidget> {
  bool isMediaUploading = false;
  String uploadedFileUrl = '';

  ApiCallResponse? apiResultvxf;
  TextEditingController? textController;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<EventsRecord>>(
      stream: queryEventsRecord(
        queryBuilder: (eventsRecord) => eventsRecord.where('supabase_id',
            isEqualTo: widget.brevet?.id?.toString()),
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
        List<EventsRecord> adminEventPageEventsRecordList = snapshot.data!;
        final adminEventPageEventsRecord =
            adminEventPageEventsRecordList.isNotEmpty
                ? adminEventPageEventsRecordList.first
                : null;
        return Title(
            title: 'AdminEventPage',
            color: FlutterFlowTheme.of(context).primaryColor,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Page Title',
                      style: FlutterFlowTheme.of(context).title2.override(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 22,
                          ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        context.pushNamed('HomePage');
                      },
                      text: 'Home',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.of(context).primaryColor,
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                actions: [],
                centerTitle: false,
                elevation: 2,
              ),
              body: SafeArea(
                child: GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(_unfocusNode),
                  child: Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30, 30, 30, 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      EventCardWidget(
                                        brevet: widget.brevet,
                                      ),
                                      if (false)
                                        FFButtonWidget(
                                          onPressed: () async {
                                            final selectedFile =
                                                await selectFile(
                                                    storageFolderPath: 'null',
                                                    allowedExtensions: ['pdf']);
                                            if (selectedFile != null) {
                                              setState(() =>
                                                  isMediaUploading = true);
                                              String? downloadUrl;
                                              try {
                                                downloadUrl =
                                                    await uploadSupabaseStorageFile(
                                                  bucketName: 'null',
                                                  selectedMedia: selectedFile,
                                                );
                                              } finally {
                                                isMediaUploading = false;
                                              }
                                              if (downloadUrl != null) {
                                                setState(() => uploadedFileUrl =
                                                    downloadUrl!);
                                              } else {
                                                setState(() {});
                                                return;
                                              }
                                            }
                                          },
                                          text: 'Importer GPX',
                                          options: FFButtonOptions(
                                            height: 40,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor,
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
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: textController,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Localité',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2,
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              apiResultvxf =
                                                  await NominatimSearchCall
                                                      .call(
                                                city: textController!.text,
                                              );
                                              if ((apiResultvxf?.succeeded ??
                                                  true)) {
                                                final eventsUpdateData = {
                                                  'checkpoints':
                                                      FieldValue.arrayUnion([
                                                    getCheckpointFirestoreData(
                                                      createCheckpointStruct(
                                                        location:
                                                            functions.toLatLng(
                                                                NominatimSearchCall
                                                                    .latitude(
                                                                  (apiResultvxf
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                ).toString(),
                                                                NominatimSearchCall
                                                                    .longitude(
                                                                  (apiResultvxf
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                ).toString()),
                                                        city: textController!
                                                            .text,
                                                        clearUnsetFields: false,
                                                      ),
                                                      true,
                                                    )
                                                  ]),
                                                };
                                                await adminEventPageEventsRecord!
                                                    .reference
                                                    .update(eventsUpdateData);
                                              } else {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Erreur'),
                                                      content: Text(
                                                          'La localité est inconnue.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }

                                              setState(() {});
                                            },
                                            text: 'Ajouter',
                                            options: FFButtonOptions(
                                              width: 130,
                                              height: 40,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryColor,
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
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            30, 30, 30, 30),
                                        child: Builder(
                                          builder: (context) {
                                            final eventCheckpoints =
                                                adminEventPageEventsRecord!
                                                    .checkpoints!
                                                    .toList();
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  eventCheckpoints.length,
                                              itemBuilder: (context,
                                                  eventCheckpointsIndex) {
                                                final eventCheckpointsItem =
                                                    eventCheckpoints[
                                                        eventCheckpointsIndex];
                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      eventCheckpointsItem
                                                          .city!,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 30,
                                                          borderWidth: 1,
                                                          buttonSize: 60,
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 30,
                                                          ),
                                                          onPressed: () async {
                                                            final eventsUpdateData =
                                                                {
                                                              'checkpoints':
                                                                  getCheckpointListFirestoreData(
                                                                functions.removeCheckpoint(
                                                                    eventCheckpointsItem,
                                                                    adminEventPageEventsRecord!
                                                                        .checkpoints!
                                                                        .toList()),
                                                              ),
                                                            };
                                                            await adminEventPageEventsRecord!
                                                                .reference
                                                                .update(
                                                                    eventsUpdateData);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: double.infinity,
                                child: custom_widgets.OpenStreetMap(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: double.infinity,
                                  event: adminEventPageEventsRecord!,
                                  startLocation: functions.toLatLng(
                                      widget.brevet!.latitude!.toString(),
                                      widget.brevet!.longitude!.toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
