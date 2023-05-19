import 'dart:convert';

import 'package:http/http.dart' as http;


class Hotel {
  int codigo;
  String nomeFantasia;
  String cnpj;

  Hotel({required this.codigo, required this.nomeFantasia, required this.cnpj});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      codigo: json['codigo'],
      nomeFantasia: json['nomeFantasia'],
      cnpj: json['cnpj'],
    );
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nomeFantasia': nomeFantasia,
        'cnpj': cnpj,
      };
  //funcao para salvar o Hotel na api em http://localhost:8080/api/hoteis
  static Future<bool> saveHotel(Hotel hotel) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/hoteis'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(hotel.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Falha ao salvar o hotel.');
    }
  }

  //funcao para buscar os hoteis na api em http://localhost:8080/api/hoteis
  static Future<List<Hotel>> getHoteis() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/hoteis'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Hotel> hoteis = body.map((dynamic item) => Hotel.fromJson(item)).toList();
      print(hoteis);
      return hoteis;
    } else {
      throw Exception('Não foi possível buscar os hoteis.');
    }
  }
  //funcao para atualizar um hotel em http://localhost:8080/api/hoteis
  static Future<bool> updateHotel(Hotel hotel) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/hoteis'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(hotel.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao atualizar o hotel.');
    }
  }
  //funcao para excluir um hotel na api em http://localhost:8080/api/hoteis
  static Future<bool> deleteHotel(int codigo) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/hoteis/$codigo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao excluir o hotel.');
    }
  }

}
