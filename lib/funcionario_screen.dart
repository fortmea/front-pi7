import 'package:faculhotel/models/Cargo.dart';
import 'package:faculhotel/models/Funcionario.dart';
import 'package:flutter/material.dart';

class FuncionarioScreen extends StatefulWidget {
  @override
  _FuncionarioScreenState createState() => _FuncionarioScreenState();
}

class _FuncionarioScreenState extends State<FuncionarioScreen> {
  List<Cargo> cargos = [];
  Cargo? _cargoSelecionado;

  atualizarCargos() async {
    await Cargo.getCargos().then((value) {
      print("caraca");
      setState(() {
        cargos = value;
      });
    });
  }

  //controllers para nome e cpf do funcionario
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  //dialogo para atualizar o funcionario

  void _dialogAtualizar(BuildContext context, Funcionario funcionario) async {
    _cargoSelecionado = funcionario.cargo;
    await atualizarCargos();
    _nomeController.text = funcionario.nome!;
    _cpfController.text = funcionario.cpf!;
    _cargoSelecionado = funcionario.cargo;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Atualizar Funcionário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(hintText: 'Nome'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _cpfController,
                decoration: InputDecoration(hintText: 'CPF'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<Cargo>(
                decoration: InputDecoration(hintText: 'Cargo'),
                items: cargos.map((Cargo cargo) {
                  return DropdownMenuItem<Cargo>(
                    value: cargo,
                    child: Text(cargo.nome),
                  );
                }).toList(),
                onChanged: (Cargo? cargo) {
                  setState(() {
                    _cargoSelecionado = cargo;
                  });
                },
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
              onPressed: () async {
                Funcionario funcionarioAtualizado = Funcionario(
                  codigo: funcionario.codigo,
                  nome: _nomeController.text,
                  cpf: _cpfController.text,
                  cargo: _cargoSelecionado,
                );
                await Funcionario.updateFuncionario(funcionarioAtualizado);
                setState(() {
                  _nomeController.clear();
                  _cpfController.clear();
                  _cargoSelecionado = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  //dialogo para adicionar funcionario, carregando os cargos a partir da api utilizando a classe cargo e funcionario
  void adicionarFuncionario() async {
    await atualizarCargos();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Funcionário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(hintText: 'Nome'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _cpfController,
                decoration: InputDecoration(hintText: 'CPF'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<Cargo>(
                decoration: InputDecoration(hintText: 'Cargo'),
                items: cargos.map((Cargo cargo) {
                  return DropdownMenuItem<Cargo>(
                    value: cargo,
                    child: Text(cargo.nome),
                  );
                }).toList(),
                onChanged: (Cargo? cargo) {
                  setState(() {
                    _cargoSelecionado = cargo;
                  });
                },
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
              onPressed: () {
                Funcionario funcionario = Funcionario(
                  codigo: 0,
                  nome: _nomeController.text,
                  cpf: _cpfController.text,
                  cargo: _cargoSelecionado,
                );
                Funcionario.saveFuncionario(funcionario);
                setState(() {
                  _nomeController.clear();
                  _cpfController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  //dialogo para excluir um funcionario
  void _dialogExcluir(BuildContext context, Funcionario funcionario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Funcionário'),
          content: Text('Deseja excluir o funcionário ${funcionario.nome}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Funcionario.deleteFuncionario(funcionario.codigo!);
                setState(() {});
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
        title: Text('Funcionários'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: adicionarFuncionario,
              icon: Icon(Icons.add),
              label: Text('Adicionar funcionário'),
            ),
            SizedBox(height: 16.0),
            Expanded(
                child: FutureBuilder(
              future: Funcionario.getFuncionarios(),
              builder: (context, AsyncSnapshot<List<Funcionario>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Funcionario funcionario = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text('${funcionario.nome}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _dialogAtualizar(context, funcionario);
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  _dialogExcluir(context, funcionario);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
