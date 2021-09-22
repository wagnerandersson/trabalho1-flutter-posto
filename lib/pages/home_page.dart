import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'lista.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calcule o combustivel ideal'),
        ),
        body: ListView(children: <Widget>[appBody(context), DataForm()]));
  }

  Column appBody(BuildContext context) {
    return Column(
      children: <Widget>[
        appBodyTitle(),
        appBodyImages(),
      ],
    );
  }

  Container appBodyTitle() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Center(
        child: Text(
          'Insira os valores dos combustiveis nos campos abaixo',
          style: TextStyle(
            fontSize: 18,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Container appBodyImages() {
    return Container(
      padding: EdgeInsets.all(16),
      height: 100,
      child: PageView(
        children: <Widget>[appBodyImage("images/bocal.jpg")],
      ),
    );
  }

  Image appBodyImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
    );
  }
}

class DataForm extends StatefulWidget {
  const DataForm({Key? key}) : super(key: key);

  @override
  _DataFormState createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  var _gas = TextEditingController();
  var _alcool = TextEditingController();
  var _name = TextEditingController();
  String _melhor = " ";

  String _mensagem = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(children: <Widget>[
          TextFormField(
              controller: _gas,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                  icon: Icon(Icons.garage_sharp),
                  labelText: "Valor da Gasolina")),
          TextFormField(
              controller: _alcool,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                  icon: Icon(Icons.garage_sharp),
                  labelText: "Valor do Etanol")),
          TextFormField(
              controller: _name,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                  icon: Icon(Icons.garage_sharp), labelText: "Nome do Posto")),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: () {
                double gasolina = double.parse(_gas.text);
                double etanol = double.parse(_alcool.text);
                double resultado = etanol / gasolina;

                if (resultado < 0.7) {
                  _melhor = "Etanol";
                } else {
                  _melhor = "Gasolina";
                }

                setState(() {
                  _mensagem = "Abasteça com ${_melhor}";
                });
              },
              child: Text(' Calcular ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _mensagem,
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: () {
                _addProduto();
              },
              child: Text(' Lembrar ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: () async {
                mostraLista(context);
                // print(await _readData());
              },
              child: Text(' Ver Lista',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  )),
            ),
          ),
        ]));
  }

  List _postos = [];

  _addProduto() {
    String posto = _name.text;
    String gas = _gas.text;
    String alcool = _alcool.text;
    String melhor = _melhor;

    var novoPosto = new Map();

    novoPosto["nome"] = posto;
    novoPosto["gas"] = gas;
    novoPosto["alcool"] = alcool;
    novoPosto["melhor"] = melhor;

    setState(() {
      _postos.add(novoPosto);
      _name.text = "";
    });

    _saveData();
  }

  Future<File> _getFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    return File(appDocPath + "/postos.json");
  }

  Future<File> _saveData() async {
    String postos = json.encode(_postos);

    final file = await _getFile();
    return file.writeAsString(postos);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print("Erro na leitura do arquivo ${e.toString()}");
      return "";
    }
  }

  void mostraLista(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Lista()));
  }
}
