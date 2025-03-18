import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para carregar o JSON

class OfertasPage extends StatefulWidget {
  @override
  _OfertasPageState createState() => _OfertasPageState();
}

class _OfertasPageState extends State<OfertasPage> {
  List<Map<String, dynamic>> _ofertas = [];
  bool _erro = false;

  @override
  void initState() {
    super.initState();
    _carregarOfertas();
  }

  // Função para carregar as ofertas do JSON
  Future<void> _carregarOfertas() async {
    try {
      final String response = await rootBundle.loadString('json/ofertas.json');
      final Map<String, dynamic> data = json.decode(response);

      if (data.containsKey('ofertas') && data['ofertas'] is List) {
        setState(() {
          _ofertas = List<Map<String, dynamic>>.from(data['ofertas']);
        });
      } else {
        throw Exception("Formato inválido do JSON");
      }
    } catch (e) {
      print("Erro ao carregar ofertas: $e");
      setState(() {
        _erro = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ofertas Especiais"),
        backgroundColor: Color(0xFF457B9D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _erro
            ? Center(child: Text("Erro ao carregar ofertas", style: TextStyle(fontSize: 18, color: Colors.red)))
            : _ofertas.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _ofertas.length,
          itemBuilder: (context, index) {
            final oferta = _ofertas[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      oferta['titulo'] ?? "Sem título",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      oferta['descricao'] ?? "Sem descrição",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'R\$ ${(oferta['preco'] as num?)?.toStringAsFixed(2) ?? "0.00"}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF457B9D)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
