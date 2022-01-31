import 'package:Cuentas/forms/add.dart';
import 'package:Cuentas/objects/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Cuentas/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({required this.app});
  final FirebaseApp app;
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool euro = true;
  bool cargado = false;
  double totalActivos = 0;
  bool showActives = false;
  List<Operacion> general = [];
  String gastoGeneral = '0.00';

  void initState() {
    cargar();
    super.initState();
  }

  cargar() async {
    await _prefs.then((SharedPreferences prefs) async {
      if(prefs.getString('nombre')==null){
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/Start', (Route<dynamic> route) => false);
        return;
      }else{
        globals.usuario = prefs.getString('nombre')!;
        globals.tema = prefs.getString('tema')!;
        setState(() {

        });
        if(prefs.getString('data')!=null)
        globals.data = dataFromJson(prefs.getString('data').toString());
        totalActivos =
            globals.data.activos.euro + (globals.data.activos.dolar * 1.11);

        await _calcularGeneral().then((value) => test());
        print('dolar = ' + (globals.data.activos.dolar * 1.11).toString());
      }
    });
  }

  Operacion op =
      Operacion(fecha: "", tipo: "", monto: 0, moneda: "", confirmed: false);
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    totalActivos =
        globals.data.activos.euro + (globals.data.activos.dolar * 1.11);
    ref = database.ref();
    return Scaffold(
        backgroundColor: globals.tema == 'claro'?
        Colors.grey[200]:
        Colors.grey[800],
        appBar: AppBar(
          title: Text(globals.usuario.toString()),
          backgroundColor: Colors.black54,
          actions: [
            IconButton(onPressed: () async {
              if(globals.tema == 'claro'){
                globals.tema = 'oscuro';
                await _prefs.then((SharedPreferences prefs) {
                  prefs.setString('tema', globals.tema);
                });
              }else{
                globals.tema = 'claro';
                await _prefs.then((SharedPreferences prefs) {
                  prefs.setString('tema', globals.tema);
                });
              }
              setState(() {

              });
            }, icon: Icon(globals.tema == 'claro'?
            Icons.nightlight_round
            :Icons.wb_sunny)),
          ],
        ),
        body: cargado
            ? Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 1.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //#region ACTIVOS
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Activos ',
                                  style: TextStyle(
                                      color: globals.tema == 'claro'?
                                      Colors.grey[700]:
                                      Colors.grey[300],
                                      fontSize: 13),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(
                                  showActives
                                      ? '≈\€ ' + totalActivos.toStringAsFixed(2)
                                      : '≈\€ ****',
                                  style: TextStyle(
                                      color: globals.tema == 'claro'?
                                      Colors.blue[800]:
                                      Colors.blue,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showActives = !showActives;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: globals.tema == 'claro'?
                                    Colors.blue[800]:
                                    Colors.blue,
                                    size: 28,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //#endregion
                      //#region GASTOS INDIVIDUAL
                      Card(
                        color: globals.tema == 'claro'?
                        Colors.white:
                        Colors.grey[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Individual',
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.blue[800]:
                                          Colors.blue[300],
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ingresos',
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      _ingresos(),
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Gastos',
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      _gastos(),
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      elevation: 5,
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pushNamed('/Details',
                                              arguments: Args(operaciones:
                                              globals.data.operaciones as List<Operacion>,
                                              cuenta: "Individual"));
                                        },
                                        child: Container(
                                          width: 100,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  child: Icon(
                                                    Icons.search,
                                                    color: globals.tema == 'claro'?
                                                    Colors.blue[800]:
                                                    Colors.blue,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: globals.tema == 'claro'?
                                      Colors.blue[800]:
                                      Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      elevation: 5,
                                      child: InkWell(
                                        onTap: () async {
                                          await Operaciones()
                                              .add(context)
                                              .then((value) => ingresar(value));
                                        },
                                        child: Container(
                                          width: 100,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //#endregion
                      //#region GASTOS GRUPAL
                      Card(
                        color: globals.tema == 'claro'?
                        Colors.white:
                        Colors.grey[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'General',
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.blue[800]:
                                          Colors.blue[300],
                                          fontSize: 20),
                                    ),
                                    // Text('asda',
                                    //   style: TextStyle(
                                    //       color: Colors.blue[800],
                                    //       fontSize: 15
                                    //   ),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Gastos',
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      gastoGeneral,
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      _totalGeneral(),
                                      style: TextStyle(
                                          color: globals.tema == 'claro'?
                                          Colors.grey[700]:
                                          Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      elevation: 5,
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pushNamed('/Details',
                                              arguments: Args(operaciones:
                                              general,
                                                  cuenta: "General"));
                                        },
                                        child: Container(
                                          width: 100,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  child: Icon(
                                                    Icons.search,
                                                    color: globals.tema == 'claro'?
                                                    Colors.blue[800]:
                                                    Colors.blue,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: globals.tema == 'claro'?
                                      Colors.blue[800]:
                                      Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      elevation: 5,
                                      child: InkWell(
                                        onTap: () async {
                                          await Operaciones()
                                              .addGeneral(context)
                                              .then((value) =>
                                                  ingresarGeneral(value));
                                        },
                                        child: Container(
                                          width: 100,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //#endregion
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  ingresar(Operacion operation) async {
    print('recibe ' + operation.monto.toString());
    if (operation.moneda == "\$ DOLAR") {
      if (operation.tipo == 'GASTO') {
        globals.data.activos.dolar -= operation.monto;
      } else {
        globals.data.activos.dolar += operation.monto;
      }
    } else {
      if (operation.tipo == 'GASTO') {
        globals.data.activos.euro -= operation.monto;
      } else {
        globals.data.activos.euro += operation.monto;
      }
    }
    globals.data.operaciones!.add(operation);
    await _prefs.then((SharedPreferences prefs) {
      prefs.setString('data', dataToJson(globals.data));
    });
    setState(() {});
  }

  String _ingresos() {
    double ingresos = 0;
    globals.data.operaciones!.forEach((element) {
      if (element.tipo == 'INGRESO') {
        if (element.moneda == "\$ DOLAR") {
          ingresos += (element.monto * 1.11);
        } else {
          ingresos += element.monto;
        }
      }
    });
    return "\€ " + ingresos.toStringAsFixed(2);
  }

  String _gastos() {
    double ingresos = 0;
    globals.data.operaciones!.forEach((element) {
      if (element.tipo == 'GASTO') {
        if (element.moneda == "\$ DOLAR") {
          ingresos -= (element.monto * 1.11);
        } else {
          ingresos -= element.monto;
        }
      }
    });
    return "\€ " + ingresos.toStringAsFixed(2);
  }

  Future<void> _calcularGeneral() async {
    general=[];
    ref = FirebaseDatabase.instance.reference();
    ref
        .once()
        .then((event) async {
          DataSnapshot dataSnapshot = event.snapshot;
          dataSnapshot.children.first.children.forEach((element) {
            element.ref
                .once()
                .then((value) => _convertir(value.snapshot.value));
          });
        });
  }

  _convertir(Object? value){
    general.add(_parse(value));
    _gastosGeneral();
    setState(() {

    });
  }

  test(){
    cargado = true;
    print('actualizado1');
    setState(() {

    });
  }

  _parse(var value) {
    Operacion op = Operacion(
        fecha: "", tipo: "", monto: 0, moneda: "", confirmed: false, user: "");
    var map = value as Map<Object?, dynamic?>;
    map.forEach((key, value) {
      if (key == "fecha") {
        op.fecha = value;
      } else if (key == "tipo") {
        op.tipo = value;
      } else if (key == "monto") {
        op.monto = double.parse(value.toString());
      } else if (key == "moneda") {
        op.moneda = value;
      } else if (key == "confirmed") {
        op.confirmed = value;
      } else if (key == "user") {
        op.user = value;
      }else if (key == "detalle") {
        op.detalle = value;
      }
    });

    print(op.toJson());
    return op;
  }

  ingresarGeneral(Operacion value) {
    if (value.confirmed == true) {
      DatabaseReference itemRef;
      final FirebaseDatabase database = FirebaseDatabase
          .instance; //Rather then just writing FirebaseDatabase(), get the instance.
      itemRef = database.reference().child('operaciones');
      itemRef.push().set(value.toJson());
      _calcularGeneral();
    }
  }

  void _gastosGeneral() {
    double gastoGen = 0;
    general.forEach((element) {
      gastoGen += element.monto;
      print(element.monto);
    });
    gastoGeneral = gastoGen.toStringAsFixed(2);
  }

  String _totalGeneral() {
    double gastoGen = 0;
    general.forEach((element) {
      if (element.user != globals.usuario) gastoGen += element.monto;
    });
    return gastoGen.toStringAsFixed(2);
  }

  actualizar() {
    setState(() {
      print('se actualizo ' + general.length.toString());
    });
  }
}
class Args{
  List<Operacion> operaciones;
  String cuenta;
  Args({required this.operaciones, required this.cuenta});
}
