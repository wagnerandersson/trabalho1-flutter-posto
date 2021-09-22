import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listagem dos postos"),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _showMaterialDialog,
        tooltip: "Limpar Lista",
        child: const Icon(Icons.autorenew),
      ),
    );
  }

  List<dynamic> _postos = [];

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Exclusão da lista'),
            content: Text('Confirma a exclusão de todos os itens da lista?'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _postos.clear();
                      _saveData();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Sim')),
              ElevatedButton(
                onPressed: () async {
                  print(await _readData());
                  Navigator.of(context).pop();
                },
                child: Text('Não!'),
              )
            ],
          );
        });
  }

  Column _body(context) {
    return Column(
      children: <Widget>[
        _listagem(context),
      ],
    );
  }

  Expanded _listagem(context) {
    _readData().then((value) => {
          setState(() {
            _postos = json.decode(value);
          })
        });

    return Expanded(
      child: ListView.builder(
        itemCount: _postos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                "Posto: ${_postos[index]["nome"]}, va de ${_postos[index]["melhor"]} RS ${_postos[index]["gas"]}"),
          );
        },
      ),
    );
  }

  _addProduto() {
    String posto = "";

    var novoPosto = new Map();

    novoPosto["nome"] = posto;

    setState(() {
      _postos.add(novoPosto);
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
}
