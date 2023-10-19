import 'package:flutter/cupertino.dart';
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
      title: 'App Calcule de calories',
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

  dynamic radioSelected;
  late double? weight;
  late double age =0;
  bool gender = false;
  double size = 170.0;
  Map mapactivity = {
    0: "Faible",
    1: "Moderée",
    2: "Forte"
  };
  late int calorieBase;
  late int calorieActivity;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: setColor(),
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              padding(),
              textWithStyle('Remplissez tous les champs pour obtenir votre apport qualorifique journalier:'),
              padding(),
              Card(
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
                    padding(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        textWithStyle("Femme", color: Colors.pinkAccent),
                        CupertinoSwitch(
                            value: gender,
                            trackColor: Colors.pinkAccent,
                            activeColor: Colors.blueAccent,
                            onChanged: (bool b) {
                              setState(() {
                                gender = b;
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
                          weight = double.tryParse(string);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Entrez votre poids en kilo (kg)"
                      ),
                    ),
                    padding(),
                    textWithStyle("Votre taille est de, ${size.toInt()} cm", color: setColor()),
                    padding(),
                    Slider(
                      value: size,
                      onChanged: (double d){
                        setState(() {
                          size = d;
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
                    textWithStyle("Quelle est votre activité sportive ?", color: setColor()),
                    padding(),
                    rowRadio(),
                    padding(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: setColor()),
                      onPressed: _calculNombreCalories,
                      child: textWithStyle("Calculer", color: Colors.white),
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

  void _calculNombreCalories(){
    if (age != 0 && weight != null && radioSelected != null){
      //calculer
      if(gender){
        calorieBase = (66.4730 + (13.7516 * weight!) + (5.0033 * size) - (6.7550 * age)).toInt();
      } else {
        calorieBase = (665.0955 + (9.5634 * weight!) + (1.8496 * size) - (4.6756 * age)).toInt();
      }
      switch(radioSelected){
        case 0:
          calorieActivity = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieActivity = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieActivity = (calorieBase * 1.8).toInt();
          break;
      }
      setState(() {
        alertNeed();
      });
    } else {
      //Alert missing fields
      alertMissing();
    }
  }

  Future<void> alertNeed() async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return SimpleDialog(
            title: textWithStyle("Votre besoin en calorie", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: [
              padding(),
              textWithStyle("Votre besoin de base est de: $calorieBase"),
              padding(),
              textWithStyle("Votre besoin avec activité est de: $calorieActivity"),
              padding(),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: setColor()),
                  child: textWithStyle("OK", color: Colors.white)
              )
            ],
          );
        }
    );
  }

  Future<void> alertMissing() async{
    return showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: textWithStyle("Erreur"),
            content: textWithStyle("Tous les champs ne sont pas remplis"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: textWithStyle("OK", color: Colors.red)
              )
            ],
          );
        }
    );
  }
  
  Padding padding(){
    return Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Future<void> _showPicker(BuildContext context) async{
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
    if(gender){
      return Colors.blueAccent;
    } else {
      return Colors.pinkAccent;
    }
  }

  Row rowRadio(){
    List<Widget> l = [];
    mapactivity.forEach((key, value) {
      Column colonne = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
              value: key,
              groupValue: radioSelected,
              onChanged: (dynamic i){
                setState(() {
                  radioSelected = i;
                });
              }
          ),
          textWithStyle(value, color: setColor()),
        ],
      );
      l.add(colonne);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
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
