// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:task_dropper/data/models/user_model.dart';
import 'package:task_dropper/presentation/pages/home_page.dart';
import 'package:task_dropper/data/datasources/local_source.dart';
import 'package:task_dropper/presentation/pages/register_user_page.dart';
import 'package:task_dropper/utils/snackbar.utils.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalDataSource _localDataSource = LocalDataSource();
  final SnackbarUtils _snackbarUtils = SnackbarUtils();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          SizedBox(height: 30),
          
          Text(
            "LOGIN",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
      
          SizedBox(height: 20),
      
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: SizedBox(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    labelText: 'E-mail',
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.mail),
                    ),
                  ),
                ),
              ),
            ),
          ),
      
          SizedBox(height: 30),
      
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: SizedBox(
                child: TextField(
                  obscureText: _passwordInvisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: 'Senha',
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.lock),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                          icon: Icon(
                            _passwordInvisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordInvisible = !_passwordInvisible;
                            });
                          },
                        ),
                      )),
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
                      color: Colors.white
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
      
    );
  }

  void executeLogin () async {
    if (!_emailController.text.isNotEmpty) {
      final snackBar = _snackbarUtils.showCustomSnackbar('Digite o e-mail do seu usuário', Colors.red, Colors.white);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!_passwordController.text.isNotEmpty) {
      final snackBar = _snackbarUtils.showCustomSnackbar('Digite a senha do seu usuário', Colors.red, Colors.white);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    bool loginSuccess = await _localDataSource.verifyLogin(_emailController.text, _passwordController.text);

    if (loginSuccess) {
      final snackBar = _snackbarUtils.showCustomSnackbar('Login efetuado com sucesso!', Colors.green, Colors.white);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    } else {
      final snackBar = _snackbarUtils.showCustomSnackbar('Usuário não encontrado na base de dados!', Colors.red, Colors.white);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}