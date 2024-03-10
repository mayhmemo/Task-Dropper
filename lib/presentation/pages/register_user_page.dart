// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:task_dropper/data/datasources/local_source.dart';
import 'package:task_dropper/presentation/pages/login_page.dart';

class RegisterUserPage extends StatefulWidget {
  RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final LocalDataSource _localDataSource = LocalDataSource();

  TextEditingController _userController = TextEditingController();
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
            SizedBox(height: 20),
            
            Text(
              "OLÁ, VAMOS CADASTRAR SEU USUÁRIO",
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 24,
                color: Colors.black54
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
                child: Padding(
                  padding: EdgeInsets.only(left: 3.0),
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration (
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 8.0),
                        child: Icon(Icons.person),
                      ),
                      labelText: "Usuário",
                      labelStyle: TextStyle(
                        color: Colors.black
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                  controller:  _emailController,
                  decoration: InputDecoration (
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 8.0),
                      child: Icon(Icons.lock),
                    ),
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                      color: Colors.black
                    ),
                    enabledBorder:  OutlineInputBorder(
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
                  controller:  _passwordController,
                  decoration: InputDecoration (
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 8.0),
                      child: Icon(Icons.lock),
                    ),
                    labelText: "Senha",
                    labelStyle: TextStyle(
                      color: Colors.black
                    ),
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
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
                onPressed: () async {
                  bool regiserUserSuccess = await _localDataSource.registerUser(_userController.text, _emailController.text, _passwordController.text);

                  if (regiserUserSuccess) {
                    final snackBar = SnackBar(content: Text('Usuário registrado com sucesso!'), backgroundColor: Colors.green);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    });
                  } else {
                    final snackBar = SnackBar(content: Text('Falha ao tentar registrar usuário!'), backgroundColor: Colors.red);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Registrar',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
