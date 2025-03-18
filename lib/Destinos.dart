import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Destinos extends StatefulWidget {
  @override
  State<Destinos> createState() => _DestinosState();
}

class _DestinosState extends State<Destinos> {
  List<dynamic> destinos = [];

  @override
  void initState() {
    super.initState();
    carregarDestinos();
  }

  Future<void> carregarDestinos() async {
    String jsonData = await rootBundle.loadString('json/destinos.json');
    setState(() {
      destinos = jsonDecode(jsonData);
    });
  }

  void mostrarDetalhesDestino(Map<String, dynamic> destino) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  destino['nome'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Image.asset(destino['imagem'], width: 300, height: 200, fit: BoxFit.cover),
                SizedBox(height: 10),
                Text(
                  destino['localizacao'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                Text(
                  destino['descricao'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Fechar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = Color(0xFF66E0F7);
    Color borderColor = Color(0xFF0077A8);

    return Scaffold(
      appBar: AppBar(
        title: Text("Destinos"),
        backgroundColor: appBarColor,
        shape: Border(
          bottom: BorderSide(color: borderColor, width: 3),
        ),
      ),
      body: Container(
        color: Color(0xFFE0F7FA),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: destinos.length,
                  itemBuilder: (context, index) {
                    final destino = destinos[index];
                    return GestureDetector(
                      onTap: () => mostrarDetalhesDestino(destino),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.asset(destino['imagem'], fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                destino['nome'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: appBarColor,
          border: Border(
            top: BorderSide(color: Color(0xFF0077A8), width: 5),
            right: BorderSide(color: Color(0xFF0077A8), width: 5),
            left: BorderSide(color: Color(0xFF0077A8), width: 5),
            bottom: BorderSide(color: Color(0xFF0077A8), width: 5),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Makes the bottom bar transparent to let the border show
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