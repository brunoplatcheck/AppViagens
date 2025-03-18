import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Contatos extends StatefulWidget {
  const Contatos({super.key});

  @override
  State<Contatos> createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController assuntoController = TextEditingController();
  final TextEditingController mensagemController = TextEditingController();

  // Placeholder para imagem de contato
  final String imagemContato = 'images/contatos.png';

  // Função para salvar o e-mail em mensagens.json
  Future<void> salvarMensagem() async {
    // Crie um objeto com as informações
    final mensagem = {
      'email': emailController.text,
      'assunto': assuntoController.text,
      'mensagem': mensagemController.text,
    };

    // Carregar o arquivo JSON
    final jsonData = await rootBundle.loadString('assets/json/mensagens.json');
    final List<dynamic> mensagens = jsonDecode(jsonData);

    // Adicionar a nova mensagem
    mensagens.add(mensagem);

    // Salvar de volta no arquivo JSON (simulação)
    // Como o Flutter não permite escrita direta em arquivos locais (sem permissões ou plugin),
    // aqui estamos apenas simulando o salvamento
    print('Mensagem salva: $mensagem');
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = Color(0XFFD8727E);
    Color borderColor = Color(0xFFD84649);

    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: appBarColor,
        shape: Border(
          bottom: BorderSide(color: borderColor, width: 3),
        ),
      ),
      body: Container(
        color: Color(0xFFD8B8BB),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem Placeholder
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(imagemContato),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Informações de contato
            Text(
              "Telefone: (11) 99999-9999",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "E-mail: contato@empresa.com",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "WhatsApp: (11) 99999-9999",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            // Formulário de contato
            Text(
              "Envie-nos um e-mail:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Seu E-mail",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0XFFD8B6C4),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: assuntoController,
              decoration: InputDecoration(
                labelText: "Assunto",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0XFFD8B6C4),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: mensagemController,
              decoration: InputDecoration(
                labelText: "Mensagem",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0XFFD8B6C4),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                salvarMensagem();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mensagem enviada com sucesso!')),
                );
              },
              child: Text("Enviar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarColor,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: appBarColor,
          border: Border(
            top: BorderSide(color: Color(0xFFD84649), width: 5),
            right: BorderSide(color: Color(0xFFD84649), width: 5),
            left: BorderSide(color: Color(0xFFD84649), width: 5),
            bottom: BorderSide(color: Color(0xFFD84649), width: 5),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          ],
        ),
      ),
    );
  }
}
