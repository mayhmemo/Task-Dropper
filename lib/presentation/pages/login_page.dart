// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:task_dropper/presentation/pages/home_page.dart';
import 'package:task_dropper/data/datasources/local_source.dart';
import 'package:task_dropper/presentation/pages/register_user_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalDataSource _localDataSource = LocalDataSource();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white70, Colors.white38],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 30),
            
            Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 8.0),
                      child: Icon(Icons.lock),
                    ),
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 8.0),
                      child: Icon(Icons.lock),
                    ),
                    labelText: "Senha",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Container(
              width: double.infinity,
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  executeLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterUserPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Não tem uma conta ? ",
                      style: TextStyle(
                        color: Colors.black87
                      ),
                      children: <TextSpan> [
                        TextSpan(
                          text: "crie aqui",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none
                          )
                        )
                      ]
                    ),
                  )
                ) ,
              )
            )

          ],
        ),
      ),
      
    );
  }

  void executeLogin () async {
    bool loginSuccess = await _localDataSource.verifyLogin(_emailController.text, _passwordController.text);

    if (loginSuccess) {
      final snackBar = SnackBar(content: Text('Login efetuado com sucesso!'), backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    } else {
      final snackBar = SnackBar(content: Text('Usuário não encontrado na base de dados!'), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}
