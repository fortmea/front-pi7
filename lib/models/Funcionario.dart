import 'package:flutter/foundation.dart';
import 'Cargo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Funcionario {
  int? codigo;
  String? nome;
  String? cpf;
  Cargo? cargo;

  Funcionario({
    this.codigo,
    this.nome,
    this.cpf,
    this.cargo,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      codigo: json['codigo'] as int?,
      nome: json['nome'] as String?,
      cpf: json['cpf'] as String?,
      cargo: json['cargo'] != null ? Cargo.fromJson(json['cargo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nome': nome,
      'cpf': cpf,
      'cargo': cargo?.toJson(),
    };
  }
  
  // Função para buscar funcionários na API em http://localhost:3000/api/integrador/funcionario
  static Future<List<Funcionario>> getFuncionarios() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/integrador/funcionario'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Funcionario> funcionarios = body.map((dynamic item) => Funcionario.fromJson(item)).toList();
      return funcionarios;
    } else {
      throw Exception('Não foi possível buscar os funcionários.');
    }
  }

  // Função para salvar um funcionário na API em http://localhost:3000/api/integrador/funcionario
  static Future<bool> saveFuncionario(Funcionario funcionario) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/integrador/funcionario'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(funcionario.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao salvar o funcionário.');
    }
  }

  // Função para atualizar um funcionário na API em http://localhost:3000/api/integrador/funcionario/:codigo
  static Future<bool> updateFuncionario(Funcionario funcionario) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/integrador/funcionario'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(funcionario.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao atualizar o funcionário.');
    }
  }

  // Função para excluir um funcionário na API em http://localhost:3000/api/integrador/funcionario/:codigo
  static Future<bool> deleteFuncionario(int codigo) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/integrador/funcionario?codigo=$codigo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao excluir o funcionário.');
    }
  }
}