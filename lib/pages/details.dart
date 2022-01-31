import 'package:Cuentas/objects/data.dart';
import 'package:Cuentas/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Cuentas/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  Details({required this.args});
  final Args args;
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool todos = true;
  bool gastos = false;
  bool ingresos = false;
  List<Operacion> lista = [];
  String cuenta = '';

  Widget build(BuildContext context) {
    cuenta = widget.args.cuenta;
    if (todos == true) {
      lista = widget.args.operaciones;
    } else {
      lista = _filtrar();
    }
    _ordenarLista(lista);
    return Scaffold(
        backgroundColor:
            globals.tema == 'claro' ? Colors.grey[200] : Colors.grey[800],
        appBar: AppBar(
          title: Text(widget.args.cuenta.toString()),
          backgroundColor: Colors.black54,
          actions: [
            IconButton(
                onPressed: () async {
                  if (globals.tema == 'claro') {
                    globals.tema = 'oscuro';
                    await _prefs.then((SharedPreferences prefs) {
                      prefs.setString('tema', globals.tema);
                    });
                  } else {
                    globals.tema = 'claro';
                    await _prefs.then((SharedPreferences prefs) {
                      prefs.setString('tema', globals.tema);
                    });
                  }
                  setState(() {});
                },
                icon: Icon(globals.tema == 'claro'
                    ? Icons.nightlight_round
                    : Icons.wb_sunny)),
          ],
        ),
        body: Column(
          children: [
            //#region FILTRO
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          todos = true;
                          gastos = false;
                          ingresos = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text('Todo',
                              style: TextStyle(
                                color: globals.tema == 'claro'
                                    ? Colors.grey[700]
                                    : Colors.white,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 2,
                              width: 80,
                              color: todos == true ? Colors.blue : null,
                            ),
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          todos = false;
                          gastos = true;
                          ingresos = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text('Gastos',
                              style: TextStyle(
                                color: globals.tema == 'claro'
                                    ? Colors.grey[700]
                                    : Colors.white,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 2,
                              width: 80,
                              color: gastos == true ? Colors.blue : null,
                            ),
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          todos = false;
                          gastos = false;
                          ingresos = true;
                        });
                      },
                      child: Column(
                        children: [
                          Text('Ingresos',
                              style: TextStyle(
                                color: globals.tema == 'claro'
                                    ? Colors.grey[700]
                                    : Colors.white,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 2,
                              width: 80,
                              color: ingresos == true ? Colors.blue : null,
                            ),
                          )
                        ],
                      )),
                ),
              ],
            )),
            //#endregion
            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: cuenta == 'General'
                              ? lista[index].user != globals.usuario
                                  ? Colors.red[200]
                                  : globals.tema == 'claro'
                                      ? Colors.white
                                      : Colors.grey[600]
                              : globals.tema == 'claro'
                                  ? Colors.white
                                  : Colors.grey[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: InkWell(
                            onTap: () async {
                              if(cuenta=='Individual'){
                                _borrar(context,lista[index]);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Text(
                                            _parseDate(lista[index].fecha),
                                            style: TextStyle(
                                                color: globals.tema == 'claro'
                                                    ? Colors.grey[700]
                                                    : Colors.white,
                                                fontSize: 15),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Text(
                                            lista[index].detalle.toString(),
                                            style: TextStyle(
                                                color: globals.tema == 'claro'
                                                    ? Colors.grey[700]
                                                    : Colors.white,
                                                fontSize: 15),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Text(
                                            cuenta == 'General'?
                                            lista[index].user.toString():
                                            lista[index].tipo,
                                            style: TextStyle(
                                                color: globals.tema == 'claro'
                                                    ? Colors.grey[700]
                                                    : Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Text(
                                            _parseMonto(index),
                                            style: TextStyle(
                                                color: cuenta == "General"?
                                                globals.tema == 'claro'
                                                    ? Colors.grey[700]
                                                    : Colors.white:
                                                lista[index].tipo == 'GASTO'
                                                    ? Colors.red[200]
                                                    : Colors.green[200],
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ));
  }

  String _parseDate(String fecha) {
    String parse = '';
    DateTime f = DateTime.parse(fecha);
    parse = f.day.toString() +
        "/" +
        f.month.toString() +
        "/" +
        f.year.toString() +
        " ~ " +
        f.hour.toString() +
        ":" +
        f.minute.toString();
    return parse;
  }

  String _parseMonto(int index) {
    String monto = '';
    if (lista[index].moneda == 'DOLAR') {
      double parseEur = lista[index].monto * 1.1;
      monto = '\$ ' +
          lista[index].monto.toString() +
          ' (≈ \€ ' +
          parseEur.toString() +
          ')';
    } else {
      monto = '\€ ' + lista[index].monto.toString();
    }
    if(lista[index].tipo == 'GASTO'){
      monto = '- '+monto;
    }else{
      monto = '+ '+monto;
    }
    return monto;
  }

  List<Operacion> _filtrar() {
    List<Operacion> filtro = [];
    if (gastos == true) {
      widget.args.operaciones.forEach((element) {
        if (element.tipo == "GASTO") {
          filtro.add(element);
        }
      });
    } else {
      widget.args.operaciones.forEach((element) {
        if (element.tipo == "INGRESO") {
          filtro.add(element);
        }
      });
    }
    return filtro;
  }

  void _ordenarLista(List<Operacion> lista){
    lista.sort((a, b) => DateTime.parse(b.fecha).compareTo(DateTime.parse(a.fecha)));
    // lista.forEach((element) {
    //   print(element.toJson());
    // });
  }

  void _borrar(BuildContext context, Operacion operacion) async {
    GlobalKey<FormState> _keyForm = GlobalKey();
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Desea eliminar la operacion \"'
                            + operacion.tipo.toString()+ ' '
                            + operacion.detalle.toString()
                        +'\"'),

                        ButtonBar(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            RaisedButton(
                              color: Colors.red[200],
                              onPressed: () {
                                _borrarOperacion(operacion);
                                Navigator.pop(context);
                              },
                              child: Text('Eliminar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void _borrarOperacion(Operacion operacion) {
    globals.data.operaciones!.remove(operacion);
    setState(() {

    });
  }
}
