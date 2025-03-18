import 'package:flutter/material.dart';


import 'Avaliacoes.dart';
import 'Cadastro.dart';
import 'Contatos.dart';
import 'Destinos.dart';
import 'Login.dart';
import 'Ofertas.dart';
import 'Parceiros.dart';
import 'Reservas.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _abrirReservas() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Reservas()));
  }

  void _abrirDestinos() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Destinos()));
  }

  void _abrirContatos() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Contatos()));
  }

  void _abrirParceiros() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Parceiros()));
  }

  void _abrirAvaliacoes() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Avaliacoes()));
  }

  void _abrirOfertas() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => OfertasPage()));
  }

  void _abrirLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  void _abrirCadastro() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Travel App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF56CCF2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(2)),
          side: BorderSide(color: Color(0xFFF2994A), width: 7),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0XFFF2F2F2),
          border: Border.all(color: Color(0xFFF2994A), width: 5),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logoviagens.png"),
            SizedBox(height: 32),
            _buildButtonRow([
              _buildButton("Reservas", _abrirReservas, Color(0xFF27AE60)),
              _buildButton("Destinos", _abrirDestinos, Color(0xFF2D9CDB)),
            ]),
            SizedBox(height: 32),
            _buildButtonRow([
              _buildButton("Parceiros", _abrirParceiros, Color(0xFFF4A261)),
              _buildButton("Contatos", _abrirContatos, Color(0xFFE76F51)),
              _buildButton("Ofertas", _abrirOfertas, Color(0xFF8D99AE)),
            ]),
            SizedBox(height: 32),
            _buildButtonRow([
              _buildButton("Login", _abrirLogin, Color(0xFF6A0572)),
              _buildButton("Cadastro", _abrirCadastro, Color(0xFF6A0572)),
              _buildButton("Avaliações", _abrirAvaliacoes, Color(0xFF457B9D)),
            ]),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF56CCF2),
        selectedItemColor: Colors.black,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: "Contatos"),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(text),
    );
  }

  Widget _buildButtonRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }
}
