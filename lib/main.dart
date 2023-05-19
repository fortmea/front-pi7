import 'package:faculhotel/Home.dart';
import 'package:faculhotel/Login.dart';
import 'package:faculhotel/hotel_screen.dart';
import 'package:faculhotel/quarto_screen.dart';
import 'package:flutter/material.dart';

import 'cargo_screen.dart';
import 'funcionario_screen.dart';
import 'hospedagem_screen.dart';
import 'hospede_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/cargo': (context) => CargoScreen(),
          '/funcionario': (context) => FuncionarioScreen(),
          '/quarto': (context) => QuartoScreen(),
          '/hospede': (context) => HospedeScreen(),
          '/hospedagem': (context) => HospedagemScreen(),
          '/home': (context) => const Home(),
          '/hotel': (context) => HotelScreen(),
        },
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
        ),
        title: 'Campus Hotels',
        home: Login());
  }
}
