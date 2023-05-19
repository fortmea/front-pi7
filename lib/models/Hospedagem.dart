import 'package:faculhotel/models/Funcionario.dart';
import 'package:faculhotel/models/Hospede.dart';
import 'package:faculhotel/models/Quarto.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Hospedagem {
  int codigo;
  String entrada;
  String saida;
  Funcionario funcionario;
  Hospede hospede;
  Quarto quarto;

  Hospedagem({
    required this.codigo,
    required this.entrada,
    required this.saida,
    required this.funcionario,
    required this.hospede,
    required this.quarto,
  });

  factory Hospedagem.fromJson(Map<String, dynamic> json) {
    return Hospedagem(
      codigo: json['codigo'],
      entrada: json['entrada'],
      saida: json['saida'],
      funcionario: Funcionario.fromJson(json['funcionario']),
      hospede: Hospede.fromJson(json['hospede']),
      quarto: Quarto.fromJson(json['quarto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'entrada': entrada,
      'saida': saida,
      'funcionario': funcionario.toJson(),
      'hospede': hospede.toJson(),
      'quarto': quarto.toJson(),
    };
  }

  //buscar hospedagens na api em localhost:3000/api/integrador/hospedagem
  static Future<List<Hospedagem>> getHospedagens() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/hospedagens'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Hospedagem> hospedagens =
          body.map((dynamic item) => Hospedagem.fromJson(item)).toList();
      return hospedagens;
    } else {
      throw "Não foi possível buscar as hospedagens.";
    }
  }

  //salvar hospedagem na api em localhost:3000/api/integrador/hospedagem
  static Future<bool> saveHospedagem(Hospedagem hospedagem) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/hospedagens'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(hospedagem.toJson()),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Falha ao salvar a hospedagem.');
    }
  }

  //deletar hospedagem na api em localhost:3000/api/integrador/hospedagem
  static Future<bool> deleteHospedagem(Hospedagem hospedagem) async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:8080/api/hospedagens/${hospedagem.codigo}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao deletar a hospedagem.');
    }
  }

  //atualizar hospedagem na api em localhost:3000/api/integrador/hospedagem
  static Future<bool> updateHospedagem(Hospedagem hospedagem) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/hospedagens'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(hospedagem.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao atualizar a hospedagem.');
    }
  }
}
