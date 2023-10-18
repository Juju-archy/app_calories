import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Calucl de calories',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculer mes apports quotidien'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late double? poids;
  late double age =0;
  bool genre = false;
  double taille = 170.0;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: setColor(),
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              textWithStyle('Remplissez tous les champs pour obtenir votre apport qualorifique journalier:'),
              Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
                    padding(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        textWithStyle("Femme", color: Colors.pinkAccent),
                        Switch(
                            value: genre,
                            inactiveTrackColor: Colors.pinkAccent,
                            activeTrackColor: Colors.blueAccent,
                            onChanged: (bool b) {
                              setState(() {
                                genre = b;
                              });
                            }
                        ),
                        textWithStyle("Homme", color: Colors.blueAccent)
                      ],
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String string){
                        setState(() {
                          poids = double.tryParse(string);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Entrez votre poids en kilo (kg)"
                      ),
                    ),
                    padding(),
                    textWithStyle("Votre taille est de, ${taille.toInt()} cm", color: setColor()),
                    padding(),
                    Slider(
                      value: taille,
                      onChanged: (double d){
                        setState(() {
                          taille = d;
                        });
                      },
                      max: 220.0,
                      min: 85.0,
                      activeColor: setColor(),
                    ),
                    ElevatedButton(
                        onPressed: () => _showPicker(context),
                        style: ElevatedButton.styleFrom(backgroundColor: setColor()),
                        child: textWithStyle((age == 0)? 'Appuyez pour entrer votre âge:': 'Vous avez ${age.toInt()} ans.',
                        color: Colors.white)
                    ),
                    padding(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Padding padding(){
    return Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Future<Null> _showPicker(BuildContext context) async{
    DateTime? choix = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if(choix != null){
      var difference = DateTime.now().difference(choix);
      var days = difference.inDays;
      var years = (days / 365);
      setState(() {
        age = years;
      });
    }
  }

  Color setColor(){
    if(genre){
      return Colors.blueAccent;
    } else {
      return Colors.pinkAccent;
    }
  }

  Text textWithStyle(String data, {color = Colors.black, fontSize = 15.0}){
    return Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      )
    );
  }
}
