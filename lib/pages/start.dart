import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Start extends StatefulWidget{

  _StartState createState() => _StartState();
}

class _StartState extends State<Start>{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String nombre='';
  String tema = 'claro';
  
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: tema=='oscuro'?Colors.grey[800]:Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(onPressed: (){
                          tema = 'claro';
                          setState(() {

                          });
                        }, icon: Icon(Icons.wb_sunny,
                            color: tema=='oscuro'?
                            Colors.white:
                            Colors.grey[800])),
                        IconButton(onPressed: (){
                          tema = 'oscuro';
                          setState(() {

                          });
                        }, icon: Icon(Icons.nightlight_round,
                            color: tema=='oscuro'?
                            Colors.white:
                            Colors.grey[800])),
                      ],
                    ),
                  ),
                  Text(
                    'Nombre',
                    style: TextStyle(
                        fontSize: 25,
                      color:tema=='oscuro'?
                    Colors.white:
                        Colors.grey[800]
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 20,
                          color: tema=='oscuro'?
                          Colors.white:
                          Colors.grey[800]
                      ),
                      onChanged: (value){
                        nombre = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          _comenzar();
                        },
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: const [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      10, 10, 10, 10),
                                  child: Text(
                                    "Comenzar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _comenzar() async {

    await _prefs.then((SharedPreferences prefs) {
      prefs.setString('nombre', nombre);
      prefs.setString('tema', tema);
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
  }
}