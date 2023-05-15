import 'package:faculhotel/models/Funcionario.dart';
import 'package:faculhotel/models/Hospedagem.dart';
import 'package:faculhotel/models/Hospede.dart';
import 'package:faculhotel/models/Quarto.dart';
import 'package:flutter/material.dart';

class HospedagemScreen extends StatefulWidget {
  @override
  _HospedagemScreenState createState() => _HospedagemScreenState();
}

class _HospedagemScreenState extends State<HospedagemScreen> {
  TextEditingController _dataEntradaController = TextEditingController();
  TextEditingController _dataSaidaController = TextEditingController();

  List<Funcionario> funcionarios = [];
  List<Quarto> quartos = [];
  List<Hospede> hospedes = [];
  Hospede? _hospedeSelecionado;
  Quarto? _quartoSelecionado;
  Funcionario? _funcionarioSelecionado;
  atualizarFuncionarios() async {
    await Funcionario.getFuncionarios().then((value) {
      setState(() {
        funcionarios = value;
      });
    });
  }

  atualizarQuartos() async {
    await Quarto.getQuartos().then((value) {
      setState(() {
        quartos = value;
      });
    });
  }

  atualizarHospedes() async {
    await Hospede.getHospedes().then((value) {
      setState(() {
        hospedes = value;
      });
    });
  }

  void _dialogSalvar(BuildContext context) async {
    await atualizarFuncionarios();
    await atualizarHospedes();
    await atualizarQuartos();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Adicionar Hospedagem'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: _dataEntradaController,
                decoration: const InputDecoration(hintText: 'Data de entrada'),
              ),
              TextField(
                controller: _dataSaidaController,
                decoration: const InputDecoration(hintText: 'Data de saída'),
              ),
              DropdownButtonFormField<Quarto>(
                hint: const Text('Selecione um quarto'),
                items: quartos.map((Quarto quarto) {
                  return DropdownMenuItem<Quarto>(
                    value: quarto,
                    child: Text(quarto.numero.toString() +
                        ' - ' +
                        quarto.hotel.nomeFantasia),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _quartoSelecionado = value;
                  });
                },
              ),
              DropdownButtonFormField<Funcionario>(
                hint: const Text('Selecione um funcionário'),
                items: funcionarios.map((Funcionario funcionario) {
                  return DropdownMenuItem<Funcionario>(
                    value: funcionario,
                    child: Text(funcionario.nome! + "-" + funcionario.cpf!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _funcionarioSelecionado = value;
                  });
                },
              ),
              DropdownButtonFormField<Hospede>(
                hint: const Text('Selecione um hospede'),
                items: hospedes.map((Hospede hospede) {
                  return DropdownMenuItem<Hospede>(
                    value: hospede,
                    child: Text(hospede.nome + "-" + hospede.cpf),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _hospedeSelecionado = value;
                  });
                },
              )
            ]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                  child: const Text('Salvar'),
                  onPressed: () {
                    Hospedagem hospedagem = Hospedagem(
                        codigo: 0,
                        entrada: _dataEntradaController.text,
                        saida: _dataSaidaController.text,
                        quarto: _quartoSelecionado!,
                        funcionario: _funcionarioSelecionado!,
                        hospede: _hospedeSelecionado!);
                    setState(() {
                      Hospedagem.saveHospedagem(hospedagem);
                      _dataEntradaController.clear();
                      _dataSaidaController.clear();
                      _funcionarioSelecionado = null;
                      _hospedeSelecionado = null;
                      _quartoSelecionado = null;
                      Navigator.of(context).pop();
                    });
                  })
            ],
          );
        });
  }

  //dialogo editar hospedagem
  void _dialogEditar(BuildContext context, Hospedagem hospedagem) async {
    _dataEntradaController.text = hospedagem.entrada;
    _dataSaidaController.text = hospedagem.saida;
    _quartoSelecionado = hospedagem.quarto;
    _funcionarioSelecionado = hospedagem.funcionario;
    _hospedeSelecionado = hospedagem.hospede;
    await atualizarFuncionarios();
    await atualizarHospedes();
    await atualizarQuartos();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Editar Hospedagem'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _dataEntradaController,
                  decoration:
                      const InputDecoration(hintText: 'Data de entrada'),
                ),
                TextField(
                  controller: _dataSaidaController,
                  decoration: const InputDecoration(hintText: 'Data de saída'),
                ),
                DropdownButtonFormField<Quarto>(
                  hint: const Text('Selecione um quarto'),
                  items: quartos.map((Quarto quarto) {
                    return DropdownMenuItem<Quarto>(
                      value: quarto,
                      child: Text(quarto.numero.toString() +
                          ' - ' +
                          quarto.hotel.nomeFantasia),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _quartoSelecionado = value;
                    });
                  },
                ),
                DropdownButtonFormField<Funcionario>(
                  hint: const Text('Selecione um funcionário'),
                  items: funcionarios.map((Funcionario funcionario) {
                    return DropdownMenuItem<Funcionario>(
                      value: funcionario,
                      child: Text(funcionario.nome! + "-" + funcionario.cpf!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _funcionarioSelecionado = value;
                    });
                  },
                ),
                DropdownButtonFormField<Hospede>(
                  hint: const Text('Selecione um hospede'),
                  items: hospedes.map((Hospede hospede) {
                    return DropdownMenuItem<Hospede>(
                      value: hospede,
                      child: Text(hospede.nome + "-" + hospede.cpf),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _hospedeSelecionado = value;
                    });
                  },
                )
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                    child: const Text('Salvar'),
                    onPressed: () {
                      Hospedagem novaHospedagem = Hospedagem(
                          codigo: hospedagem.codigo,
                          entrada: _dataEntradaController.text,
                          saida: _dataSaidaController.text,
                          quarto: _quartoSelecionado!,
                          funcionario: _funcionarioSelecionado!,
                          hospede: _hospedeSelecionado!);
                      setState(() {
                        Hospedagem.updateHospedagem(novaHospedagem);
                        _dataEntradaController.clear();
                        _dataSaidaController.clear();
                        _funcionarioSelecionado = null;
                        _hospedeSelecionado = null;
                        _quartoSelecionado = null;
                        Navigator.of(context).pop();
                      });
                    })
              ]);
        });
  }

//dialogo excluir hospedagem
  void _dialogExcluir(BuildContext context, Hospedagem hospedagem) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Excluir Hospedagem'),
            content: const Text('Deseja excluir a hospedagem?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                  child: const Text('Excluir'),
                  onPressed: () {
                    setState(() {
                      Hospedagem.deleteHospedagem(hospedagem);
                      Navigator.of(context).pop();
                    });
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospedagem'),
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
              label: const Text('Adicionar hospedagem'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
                child: FutureBuilder(
              future: Hospedagem.getHospedagens(),
              builder:
                  (context, AsyncSnapshot<List<Hospedagem>> asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                      itemCount: asyncSnapshot.data!
                          .length, // TODO: Substituir pelo número de cargos
                      itemBuilder: (BuildContext context, int index) {
                        Hospedagem hospedagem = asyncSnapshot.data![index];
                        return Card(
                            elevation: 0,
                            child: Card(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                          '${hospedagem.hospede.nome} - ${hospedagem.hospede.cpf}'),
                                    ),
                                    ListTile(
                                      title: Text(
                                          '${hospedagem.quarto.numero} - ${hospedagem.quarto.hotel.nomeFantasia} - ${hospedagem.funcionario.nome}'),
                                    ),
                                    ListTile(
                                      title: Text(
                                          '${hospedagem.entrada} - ${hospedagem.saida}'),
                                    )
                                  ],
                                )),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _dialogEditar(context, hospedagem);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _dialogExcluir(context, hospedagem);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                )
                              ],
                            )));
                      });
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
