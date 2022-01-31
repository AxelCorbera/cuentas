import 'package:Cuentas/objects/data.dart';
import 'package:flutter/material.dart';
import 'package:Cuentas/globals.dart' as globals;

class Operaciones {
  String tipo = 'GASTO';
  GlobalKey<FormState> _keyForm = GlobalKey();

  Future<Operacion> add(BuildContext context) async {
    Operacion operation = Operacion(fecha: "", tipo: "", monto: 0, moneda: "",confirmed: false);
    double monto = 0;
    String moneda = "\€ EURO";
    String detalle = '';
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
                        DropdownButtonFormField(
                          value: moneda != '' ? moneda : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            setState(() {
                              moneda = value.toString();
                            });
                            //Navigator.pop(context);
                            //_direccion(context, value.toString(), '', '', '');
                          },
                          hint: Text(
                            'Moneda',
                          ),
                          isExpanded: true,
                          items: [
                            "\€ EURO",
                            "\$ DOLAR",
                          ].map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButtonFormField(
                          value: tipo != '' ? tipo : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            setState(() {
                              tipo = value.toString();
                            });
                            //Navigator.pop(context);
                            //_direccion(context, value.toString(), '', '', '');
                          },
                          hint: Text(
                            'Tipo',
                          ),
                          isExpanded: true,
                          items: [
                            "GASTO",
                            "INGRESO",
                          ].map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          initialValue: '',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Monto: ",
                          ),
                          onSaved: (value) {},
                          onChanged: (value) {
                            monto = double.parse(value.toString());
                            print(monto);
                          },
                          validator: (value) {
                            if (value.toString().isEmpty)
                              return 'Este campo es obligatorio';
                          },
                        ),
                        TextFormField(
                          initialValue: '',
                          decoration: const InputDecoration(
                            labelText: "Detalle: ",
                          ),
                          onSaved: (value) {},
                          onChanged: (value) {
                            detalle = value;
                          },
                        ),
                        ButtonBar(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            RaisedButton(
                              onPressed: () {
                                if (_keyForm.currentState!.validate()) {
                                  if(detalle==null) {
                                    detalle = "";
                                  }
                                  Operacion op = Operacion(
                                      fecha: DateTime.now().toString(),
                                      tipo: tipo,
                                      monto: monto,
                                      detalle: detalle,
                                      moneda: moneda,
                                  confirmed: true);
                                  operation = op;
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Aceptar'),
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
    return operation;
  }

  Future<Operacion> addGeneral(BuildContext context) async {
    Operacion operation = Operacion(fecha: "", tipo: "", monto: 0, moneda: "", confirmed: false);
    double monto = 0;
    String moneda = "\€ EURO";
    String detalle = '';
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
                        DropdownButtonFormField(
                          value: moneda != '' ? moneda : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            setState(() {
                              moneda = value.toString();
                            });
                            //Navigator.pop(context);
                            //_direccion(context, value.toString(), '', '', '');
                          },
                          hint: Text(
                            'Moneda',
                          ),
                          isExpanded: true,
                          items: [
                            "\€ EURO",
                            "\$ DOLAR",
                          ].map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButtonFormField(
                          value: tipo != '' ? tipo : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            setState(() {
                              tipo = value.toString();
                            });
                            //Navigator.pop(context);
                            //_direccion(context, value.toString(), '', '', '');
                          },
                          hint: Text(
                            'Tipo',
                          ),
                          isExpanded: true,
                          items: [
                            "GASTO",
                            "INGRESO",
                          ].map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          initialValue: '',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Monto: ",
                          ),
                          onSaved: (value) {},
                          onChanged: (value) {
                            monto = double.parse(value.toString());
                            print(monto);
                          },
                          validator: (value) {
                            if (value.toString().isEmpty)
                              return 'Este campo es obligatorio';
                          },
                        ),
                        TextFormField(
                          initialValue: '',
                          decoration: const InputDecoration(
                            labelText: "Detalle: ",
                          ),
                          onSaved: (value) {},
                          onChanged: (value) {
                            detalle = value;
                          },
                        ),
                        ButtonBar(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            RaisedButton(
                              onPressed: () {
                                if (_keyForm.currentState!.validate()) {
                                  if(detalle==null) {
                                    detalle = "";
                                  }
                                  Operacion op = Operacion(
                                      fecha: DateTime.now().toString(),
                                      tipo: tipo,
                                      monto: monto,
                                      detalle: detalle,
                                      moneda: moneda,
                                      user: globals.usuario,
                                    confirmed: true
                                  );
                                  operation = op;
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Aceptar'),
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
    return operation;
  }
}
