import 'package:faculhotel/models/Cargo.dart';
import 'package:faculhotel/models/Hotel.dart';
import 'package:flutter/material.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cnpjController = TextEditingController();
  //popup formulario para adicionar hotel
  void _dialogSalvar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Hotel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(hintText: 'Nome'),
              ),
              TextField(
                controller: _cnpjController,
                decoration: const InputDecoration(hintText: 'CNPJ'),
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
                Hotel hotel = Hotel(
                    codigo: 0,
                    nomeFantasia: _nomeController.text,
                    cnpj: _cnpjController.text);
                await Hotel.saveHotel(hotel).then((value) {
                  setState(() {
                    _nomeController.clear();
                    _cnpjController.clear();
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

  //dialogo para atualizar hotel
  void _dialogAtualizar(BuildContext context, Hotel hotel) {
    _nomeController.text = hotel.nomeFantasia;
    _cnpjController.text = hotel.cnpj;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atualizar Hotel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(hintText: 'Nome'),
              ),
              TextField(
                controller: _cnpjController,
                decoration: const InputDecoration(hintText: 'CNPJ'),
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
                hotel.nomeFantasia = _nomeController.text;
                hotel.cnpj = _cnpjController.text;
                await Hotel.updateHotel(hotel).then((value) {
                  setState(() {
                    _nomeController.clear();
                    _cnpjController.clear();
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

  //dialogo para deletar hotel
  void _dialogDeletar(BuildContext context, Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deletar Hotel'),
          content:
              Text('Deseja realmente deletar o hotel ${hotel.nomeFantasia}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Hotel.deleteHotel(hotel.codigo).then((value) {
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
        title: const Text('Hotéis'),
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
              label: const Text('Adicionar hotel'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder(
                future: Hotel.getHoteis(),
                builder: (context, AsyncSnapshot<List<Hotel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Hotel hotel = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Text(hotel.nomeFantasia),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _dialogAtualizar(context, hotel);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _dialogDeletar(context, hotel);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
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
