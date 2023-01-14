import '../database.dart';

class BrevetsTable extends SupabaseTable<BrevetsRow> {
  @override
  String get tableName => 'brevets';

  @override
  BrevetsRow createRow(Map<String, dynamic> data) => BrevetsRow(data);
}

class BrevetsRow extends SupabaseDataRow {
  BrevetsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BrevetsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);

  int? get distance => getField<int>('distance');
  set distance(int? value) => setField<int>('distance', value);

  String? get date => getField<String>('date');
  set date(String? value) => setField<String>('date', value);

  String? get codeClub => getField<String>('codeClub');
  set codeClub(String? value) => setField<String>('codeClub', value);

  String? get nomorganisateur => getField<String>('nomorganisateur');
  set nomorganisateur(String? value) =>
      setField<String>('nomorganisateur', value);

  String? get mailorganisateur => getField<String>('mailorganisateur');
  set mailorganisateur(String? value) =>
      setField<String>('mailorganisateur', value);

  String? get maplink => getField<String>('maplink');
  set maplink(String? value) => setField<String>('maplink', value);

  String? get clubwebsite => getField<String>('clubwebsite');
  set clubwebsite(String? value) => setField<String>('clubwebsite', value);

  String? get gpxUrl => getField<String>('gpx_url');
  set gpxUrl(String? value) => setField<String>('gpx_url', value);
}
