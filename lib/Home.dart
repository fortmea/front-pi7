import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Campus Hotels'),
        ),
        backgroundColor: Color(0xff7697d2),
        body: Center(
          child: SizedBox(
              width: MediaQuery.of(context).devicePixelRatio * 350,
              height: MediaQuery.of(context).devicePixelRatio * 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cargo');
                    },
                    child: Text('Cargo'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/funcionario");
                    },
                    child: Text('Funcionário'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/quarto');
                    },
                    child: Text('Quarto'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/hospede",
                      );
                    },
                    child: Text('Hóspede'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/hospedagem",
                      );
                    },
                    child: Text('Hospedagem'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/hotel",
                      );
                    },
                    child: Text('Hotéis'),
                  ),
                ],
              )),
        ));
  }
}
