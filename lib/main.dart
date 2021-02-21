//import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
//import 'package:async/async.dart';

//import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:async/async.dart';

const request = "sua chave API";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

// Futuro é uma coisa que acontec eno futuro e vai retornar apenas no futuro
Future<Map> getData() async {
  // Fazendo requisição assinrona
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // CRIANDO OS CONTROLLERS
  final realController = TextEditingController();
  final usdController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();


  // Declarando quando o real foi alterado
  void _realChanges(String text){
      // Transformando o texto em double
      double real = double.parse(text);
      // Convertendo para dolar e euro e mostrar duas casas decimais
      usdController.text = (real/dolar).toStringAsFixed(2);
      euroController.text = (real/euro).toStringAsFixed(2);
     

  }
  void _usdChanges(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanges(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
     usdController.text = (dolar * this.euro/dolar).toStringAsFixed(2);
  }



  // Declarando as variaveis Dolar Bitcoin
  double dolar;
  double euro;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Adicionando a barra no App
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),

      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // ignore: missing_return
              case ConnectionState.none:
              // ignore: missing_return
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      "erro ao carregar dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,),
                  );
                }
                else{
                  // Pegando os valores do servidor
                   dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                   euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                   

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),

                    child: Column(
                      // Centralizando ícone
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget> [
                          Icon(Icons.monetization_on, size: 150.0, color: Colors.amber,),
                        buildTextFiel("Reais", "R\$: ", realController, _realChanges),
                        Divider(),
                        buildTextFiel("Dolares", "US\$: ", usdController, _usdChanges),
                        Divider(),
                        buildTextFiel("Euros", "EUR: ", euroController, _euroChanges),
                        Divider(),
                     

                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

// Criando função que vai criar o textFiel, eles possui o texto euro e prefix de diferente
// FUnção vai retornar um widget que é um campo de texto
Widget buildTextFiel(String label, String prefix, TextEditingController control, Function f){
  return TextField(
    controller: control,
    // Definindo decoração do input
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(

        ),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
  );

}

