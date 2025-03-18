import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Para usar o RatingBar
import 'package:flutter/services.dart'; // Para carregar o arquivo JSON

class Avaliacoes extends StatefulWidget {
  @override
  _AvaliacoesState createState() => _AvaliacoesState();
}

class _AvaliacoesState extends State<Avaliacoes> {
  List<Map<String, dynamic>> _avaliacoes = [];
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _comentarioController = TextEditingController();
  double _notaSelecionada = 0;

  @override
  void initState() {
    super.initState();
    _carregarAvaliacoes();
  }

  // Função para carregar as avaliações do JSON
  Future<void> _carregarAvaliacoes() async {
    final String response = await rootBundle.loadString('assets/avaliacoes.json');
    final data = json.decode(response);
    setState(() {
      _avaliacoes = List<Map<String, dynamic>>.from(data['avaliacoes']);
    });
  }

  // Função para adicionar uma nova avaliação
  void _adicionarAvaliacao() {
    final String usuario = _usuarioController.text;
    final String comentario = _comentarioController.text;

    if (usuario.isNotEmpty && comentario.isNotEmpty && _notaSelecionada > 0) {
      final novaAvaliacao = {
        'id': _avaliacoes.length + 1,
        'usuario': usuario,
        'comentario': comentario,
        'nota': _notaSelecionada,
        'data': DateTime.now().toString().split(' ')[0], // data no formato yyyy-mm-dd
      };

      setState(() {
        _avaliacoes.insert(0, novaAvaliacao); // Adiciona a nova avaliação na lista
      });

      // Limpa os campos após enviar
      _usuarioController.clear();
      _comentarioController.clear();
      _notaSelecionada = 0;
    }
  }

  // Função para exibir as estrelas
  Widget _buildEstrelas(double nota) {
    return RatingBarIndicator(
      rating: nota,
      itemCount: 5,
      itemSize: 30.0,
      itemBuilder: (context, index) {
        if (nota >= index + 1) {
          return Icon(Icons.star, color: Colors.orange);
        } else if (nota > index && nota < index + 1) {
          return Icon(Icons.star_half, color: Colors.orange);
        } else {
          return Icon(Icons.star_border, color: Colors.orange);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Avaliações"),
        backgroundColor: Color(0xFF457B9D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe a lista de avaliações
            Text("Avaliações Recentes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _avaliacoes.length,
                itemBuilder: (context, index) {
                  final avaliacao = _avaliacoes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: Text(avaliacao['usuario']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEstrelas(avaliacao['nota']),
                          SizedBox(height: 8),
                          Text(avaliacao['comentario']),
                          SizedBox(height: 8),
                          Text("Data: ${avaliacao['data']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Formulário para nova avaliação
            Divider(),
            Text("Escreva sua Avaliação", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _comentarioController,
              decoration: InputDecoration(labelText: 'Comentário'),
              maxLines: 3,
            ),
            SizedBox(height: 8),
            Text("Selecione sua nota"),
            RatingBar.builder(
              initialRating: _notaSelecionada,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40.0,
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.orange),
              onRatingUpdate: (rating) {
                setState(() {
                  _notaSelecionada = rating;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _adicionarAvaliacao,
              child: Text('Enviar Avaliação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF457B9D), // Correção: Use backgroundColor ao invés de primary
              ),
            ),
          ],
        ),
      ),
    );
  }
}
