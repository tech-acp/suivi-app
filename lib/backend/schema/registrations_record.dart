import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'registrations_record.g.dart';

abstract class RegistrationsRecord
    implements Built<RegistrationsRecord, RegistrationsRecordBuilder> {
  static Serializer<RegistrationsRecord> get serializer =>
      _$registrationsRecordSerializer;

  DocumentReference? get event;

  String? get id;

  @BuiltValueField(wireName: 'current_checkpoint')
  int? get currentCheckpoint;

  String? get category;

  @BuiltValueField(wireName: 'start_time')
  DateTime? get startTime;

  @BuiltValueField(wireName: 'limit_time')
  DateTime? get limitTime;

  @BuiltValueField(wireName: 'end_time')
  DateTime? get endTime;

  String? get type;

  int? get status;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(RegistrationsRecordBuilder builder) => builder
    ..id = ''
    ..currentCheckpoint = 0
    ..category = ''
    ..type = ''
    ..status = 0;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('registrations');

  static Stream<RegistrationsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<RegistrationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s))!);

  RegistrationsRecord._();
  factory RegistrationsRecord(
          [void Function(RegistrationsRecordBuilder) updates]) =
      _$RegistrationsRecord;

  static RegistrationsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createRegistrationsRecordData({
  DocumentReference? event,
  String? id,
  int? currentCheckpoint,
  String? category,
  DateTime? startTime,
  DateTime? limitTime,
  DateTime? endTime,
  String? type,
  int? status,
}) {
  final firestoreData = serializers.toFirestore(
    RegistrationsRecord.serializer,
    RegistrationsRecord(
      (r) => r
        ..event = event
        ..id = id
        ..currentCheckpoint = currentCheckpoint
        ..category = category
        ..startTime = startTime
        ..limitTime = limitTime
        ..endTime = endTime
        ..type = type
        ..status = status,
    ),
  );

  return firestoreData;
}
