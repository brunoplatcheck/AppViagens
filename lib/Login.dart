import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'Perfil.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _verificarLogin() async {
    final email = _emailController.text;
    final senha = _senhaController.text;

    // Carregar os dados de perfil do arquivo JSON no diretório de documentos
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/cadastro.json');

    if (await file.exists()) {
      String content = await file.readAsString();
      final data = json.decode(content);

      bool loginValido = false;

      for (var perfil in data) {
        if (perfil['email'] == email && perfil['senha'] == senha) {
          loginValido = true;
          // Ao encontrar o perfil, vai para a tela de perfil
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PerfilScreen(perfil: perfil)),
          );
          break;
        }
      }

      if (!loginValido) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email ou senha inválidos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhum cadastro encontrado!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color(0xFFCBE558),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Digite seu email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text("Senha", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Digite sua senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _verificarLogin();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCBE558),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Logar", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}