import 'dart:convert';

import 'package:http/http.dart' as http;

class Hospede {
  int codigo;
  String nome;
  String cpf;
  String celular;
  String email;
  String endereco;

  Hospede({
    required this.codigo,
    required this.nome,
    required this.cpf,
    required this.celular,
    required this.email,
    required this.endereco,
  });

  factory Hospede.fromJson(Map<String, dynamic> json) {
    return Hospede(
      codigo: json['codigo'],
      nome: json['nome'],
      cpf: json['cpf'],
      celular: json['celular'],
      email: json['email'],
      endereco: json['endereco'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['celular'] = this.celular;
    data['email'] = this.email;
    data['endereco'] = this.endereco;
    return data;
  }

  //buscar hospedes na api em localhost:3000/api/integrador/hospede
  static Future<List<Hospede>> getHospedes() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/hospedes'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Hospede> hospedes =
          body.map((dynamic item) => Hospede.fromJson(item)).toList();
      print(hospedes);
      return hospedes;
    } else {
      throw "Não foi possível buscar os hospedes.";
    }
  }

  //salvar hospede na api em localhost:3000/api/integrador/hospede
  static Future<bool> saveHospede(Hospede hospede) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/hospedes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(hospede.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao salvar o hospede.');
    }
  }

  //atualizar hospede na api em localhost:3000/api/integrador/hospede
  static Future<bool> updateHospede(Hospede hospede) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/hospedes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(hospede.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao atualizar o hospede.');
    }
  }

//deletar hospede na api em localhost:3000/api/integrador/hospede
  static Future<bool> deleteHospede(int codigo) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/hospedes?codigo=$codigo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao deletar o hospede.');
    }
  }
}
