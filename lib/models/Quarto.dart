import 'package:faculhotel/models/Hotel.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Quarto {
  int codigo;
  int numero;
  Hotel hotel;

  Quarto({required this.codigo, required this.numero, required this.hotel});

  factory Quarto.fromJson(Map<String, dynamic> json) {
    return Quarto(
      codigo: json['codigo'] as int,
      numero: json['numero'] as int,
      hotel: Hotel.fromJson(json['hotel']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['numero'] = this.numero;
    if (this.hotel != null) {
      data['hotel'] = this.hotel.toJson();
    }
    return data;
  }

  //buscar quartos na api em localhost:3000/api/integrador/quarto
  static Future<List<Quarto>> getQuartos() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/api/integrador/quarto'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Quarto> quartos =
          body.map((dynamic item) => Quarto.fromJson(item)).toList();
      return quartos;
    } else {
      throw "Não foi possível buscar os quartos.";
    }
  }

  //salvar quarto na api em localhost:3000/api/integrador/quarto
  static Future<bool> saveQuarto(Quarto quarto) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/integrador/quarto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(quarto.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao salvar o quarto.');
    }
  }

  //atualizar quarto na api em localhost:3000/api/integrador/quarto
  static Future<Quarto> updateQuarto(Quarto quarto) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/integrador/quarto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(quarto.toJson()),
    );
    if (response.statusCode == 200) {
      return Quarto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar o quarto.');
    }
  }

  //deletar quarto na api em localhost:3000/api/integrador/quarto
  static Future<bool> deleteQuarto(int codigo) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/integrador/quarto?codigo=$codigo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao deletar o quarto.');
    }
  }
}
