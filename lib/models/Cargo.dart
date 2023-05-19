import 'dart:convert';

import 'package:http/http.dart' as http;

class Cargo{
  late int codigo;
  late String nome;

  Cargo({required this.codigo, required this.nome,});

  Cargo.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    return data;
  }
  //buscar cargos na api em localhost:3000/api/integrador/cargo
  static Future<List<Cargo>> getCargos() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/cargos'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Cargo> cargos = body.map((dynamic item) => Cargo.fromJson(item)).toList();
      return cargos;
    } else {
      throw "Não foi possível buscar os cargos.";
    }
  }
  //salvar cargo na api em localhost:3000/api/integrador/cargo
  static Future<bool> saveCargo(Cargo cargo) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/cargos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cargo.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    } else {

      throw Exception('Falha ao salvar o cargo.');
    }
  }
  //atualizar cargo na api em localhost:3000/api/integrador/cargo
  static Future<bool> updateCargo(Cargo cargo) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/cargos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cargo.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {

      throw Exception('Falha ao atualizar o cargo.');
    }
  }
  //deletar cargo na api em localhost:3000/api/integrador/cargo
  static Future<bool> deleteCargo(int codigo) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/cargos/$codigo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {

      throw Exception('Falha ao deletar o cargo.');
    }
  }
}


