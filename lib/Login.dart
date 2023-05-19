import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Campus Hotels'),
        ),
        body: Center(
            child: SizedBox(
                width: MediaQuery.of(context).devicePixelRatio * 350,
                height: MediaQuery.of(context).devicePixelRatio * 250,
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Usuário',
                              ),
                            ),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Senha',
                                
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                },
                                child: Text('Entrar'))
                          ],
                        ))))));
  }
}
