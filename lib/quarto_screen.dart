import 'package:faculhotel/models/Hotel.dart';
import 'package:faculhotel/models/Quarto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuartoScreen extends StatefulWidget {
  @override
  _QuartoScreenState createState() => _QuartoScreenState();
}

class _QuartoScreenState extends State<QuartoScreen> {
  TextEditingController _numeroController = TextEditingController();

  List<Hotel> hoteis = [];
  Hotel? _hotelSelecionado;
  atualizarHoteis() async {
    await Hotel.getHoteis().then((value) {
      setState(() {
        hoteis = value;
      });
    });
  }

//dialogo para excluir quarto
  void _dialogExcluir(BuildContext context, Quarto quarto) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Excluir Quarto'),
            content: Text('Deseja excluir o quarto ${quarto.numero}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    Quarto.deleteQuarto(quarto.codigo);
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Excluir'),
              ),
            ],
          );
        });
  }

  void _dialogSalvar(BuildContext context) async {
    await atualizarHoteis();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Adicionar Quarto'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _numeroController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(' '),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(hintText: 'Número'),
                ),
                DropdownButtonFormField<Hotel>(
                  items: hoteis.map((hotel) {
                    return DropdownMenuItem<Hotel>(
                      value: hotel,
                      child: Text(hotel.nomeFantasia),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _hotelSelecionado = value;
                    });
                  },
                )
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Quarto quarto = Quarto(
                          codigo: 0,
                          numero: int.parse(_numeroController.text),
                          hotel: _hotelSelecionado!);
                      Quarto.saveQuarto(quarto);
                      _numeroController.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
              ]);
        });
  }

  void _dialogAtualizar(BuildContext context, Quarto quarto) async {
    _numeroController.text = quarto.numero.toString();
    _hotelSelecionado = quarto.hotel;
    await atualizarHoteis();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Atualizar Quarto'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _numeroController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(' '),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(hintText: 'Número'),
                ),
                DropdownButtonFormField<Hotel>(
                  items: hoteis.map((hotel) {
                    return DropdownMenuItem<Hotel>(
                      value: hotel,
                      child: Text(hotel.nomeFantasia),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _hotelSelecionado = value;
                    });
                  },
                )
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      quarto.numero = int.parse(_numeroController.text);
                      quarto.hotel = _hotelSelecionado!;
                      Quarto.updateQuarto(quarto);
                      _numeroController.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Salvar'),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quartos'),
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
              label: Text('Adicionar Quartos'),
            ),
            SizedBox(height: 16.0),
            Expanded(
                child: FutureBuilder(
              future: Quarto.getQuartos(),
              builder: (context, AsyncSnapshot<List<Quarto>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Quarto quarto = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Text("Quarto ${quarto.numero}"),
                            subtitle: Text(quarto.hotel.nomeFantasia),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _dialogAtualizar(context, quarto);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _dialogExcluir(context, quarto);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
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
