// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    required this.activos,
    required this.operaciones,
  });

  Activos activos;
  List<Operacion>? operaciones;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    activos: Activos.fromJson(json["activos"]),
    operaciones: List<Operacion>.from(json["operaciones"].map((x) => Operacion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "activos": activos.toJson(),
    "operaciones": List<dynamic>.from(operaciones!.map((x) => x.toJson())),
  };
}

class Activos {
  Activos({
    required this.dolar,
    required this.euro,
  });

  double dolar;
  double euro;

  factory Activos.fromJson(Map<String, dynamic> json) => Activos(
    dolar: json["dolar"],
    euro: json["euro"],
  );

  Map<String, dynamic> toJson() => {
    "dolar": dolar,
    "euro": euro,
  };
}

class Operacion {
  Operacion({
    required this.fecha,
    required this.tipo,
    required this.monto,
    this.detalle,
    required this.moneda,
    this.user,
    required this.confirmed
  });

  String fecha;
  String tipo;
  double monto;
  String? detalle;
  String moneda;
  String? user;
  bool confirmed;

  factory Operacion.fromJson(Map<String, dynamic> json) => Operacion(
    fecha: json["fecha"],
    tipo: json["tipo"],
    monto: json["monto"],
    detalle: json["detalle"],
    moneda: json["moneda"],
    user: json["user"],
    confirmed: json["confirmed"],
  );

  Map<String, dynamic> toJson() => {
    "fecha": fecha,
    "tipo": tipo,
    "monto": monto,
    "detalle": detalle,
    "moneda": moneda,
    "user": user,
    "confirmed": confirmed,
  };

}
