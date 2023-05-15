import 'package:faculhotel/models/Hospede.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HospedeScreen extends StatefulWidget {
  @override
  _HospedeScreenState createState() => _HospedeScreenState();
}

class _HospedeScreenState extends State<HospedeScreen> {
  //controladores para pegar os dados do dialog
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  void _dialogSalvar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Hospede'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(hintText: 'Nome'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _cpfController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'CPF'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: 'Telefone'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _enderecoController,
                decoration: const InputDecoration(hintText: 'Endereço'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Hospede hospede = Hospede(
                    codigo: 0,
                    endereco: _enderecoController.text,
                    nome: _nomeController.text,
                    cpf: _cpfController.text,
                    celular: _telefoneController.text,
                    email: _emailController.text);
                await Hospede.saveHospede(hospede).then((value) {
                  setState(() {
                    _nomeController.clear();
                    _cpfController.clear();
                    _telefoneController.clear();
                    _emailController.clear();
                    _enderecoController.clear();
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

//dialogo para atualizar hospede
  void _dialogAtualizar(BuildContext context, Hospede hospede) {
    _nomeController.text = hospede.nome;
    _cpfController.text = hospede.cpf;
    _telefoneController.text = hospede.celular;
    _emailController.text = hospede.email;
    _enderecoController.text = hospede.endereco;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atualizar Hospede'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(hintText: 'Nome'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _cpfController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'CPF'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _telefoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: 'Telefone'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _enderecoController,
                decoration: const InputDecoration(hintText: 'Endereço'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Hospede hospedeAtualizado = Hospede(
                    codigo: hospede.codigo,
                    endereco: _enderecoController.text,
                    nome: _nomeController.text,
                    cpf: _cpfController.text,
                    celular: _telefoneController.text,
                    email: _emailController.text);
                await Hospede.updateHospede(hospedeAtualizado).then((value) {
                  setState(() {
                    _nomeController.clear();
                    _cpfController.clear();
                    _telefoneController.clear();
                    _emailController.clear();
                    _enderecoController.clear();
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

//dialogo para deletar hospede
  void _dialogDeletar(BuildContext context, Hospede hospede) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deletar Hospede'),
          content: Text('Deseja realmente deletar o hospede? ${hospede.nome}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Hospede.deleteHospede(hospede.codigo).then((value) {
                  setState(() {});
                });
                Navigator.of(context).pop();
              },
              child: const Text('Deletar'),
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
        title: const Text('Hospedes'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _dialogSalvar(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Hospede'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder(
                future: Hospede.getHospedes(),
                builder: (context, AsyncSnapshot<List<Hospede>> asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: asyncSnapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Hospede hospede = asyncSnapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Text(hospede.nome),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _dialogAtualizar(context, hospede);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _dialogDeletar(context, hospede);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
