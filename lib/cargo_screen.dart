import 'package:faculhotel/models/Cargo.dart';
import 'package:flutter/material.dart';

class CargoScreen extends StatefulWidget {
  @override
  _CargoScreenState createState() => _CargoScreenState();
}

class _CargoScreenState extends State<CargoScreen> {
  TextEditingController _nomeController = TextEditingController();

  //popup formulario para adicionar cargo
  void _dialogSalvar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Cargo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(hintText: 'Nome'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{
                Cargo cargo = Cargo(codigo: 0, nome: _nomeController.text);
                await Cargo.saveCargo(cargo).then((value) {
                  setState(() {
                    _nomeController.clear();
                  });
                }
                
                );
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
  //dialogo para atualizar cargo
  void _dialogAtualizar(BuildContext context, Cargo cargo) {
    _nomeController.text = cargo.nome;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Atualizar Cargo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(hintText: 'Nome'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{
                cargo.nome = _nomeController.text;
                await Cargo.updateCargo(cargo).then((value) {
                  setState(() {
                    _nomeController.clear();
                  });
                }
                
                );
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

//dialogo de confirmação de exclusão
  void _dialogExcluir(BuildContext context, Cargo cargo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Cargo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Deseja excluir o cargo ${cargo.nome}?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{
                await Cargo.deleteCargo(cargo.codigo).then((value) {
                  setState(() {
                    _nomeController.clear();
                  });
                }
                
                );
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargos'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _dialogSalvar(context);
              },
              icon: Icon(Icons.add),
              label: Text('Adicionar cargo'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder(
                future: Cargo.getCargos(),
                builder: (context, AsyncSnapshot<List<Cargo>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].nome),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _dialogAtualizar(context, snapshot.data![index]);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _dialogExcluir(context, snapshot.data![index]);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
