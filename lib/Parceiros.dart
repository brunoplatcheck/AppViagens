import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Parceiros extends StatefulWidget {
  @override
  State<Parceiros> createState() => _ParceirosState();
}

class _ParceirosState extends State<Parceiros> {
  List<dynamic> parceiros = [];

  @override
  void initState() {
    super.initState();
    carregarParceiros();
  }

  Future<void> carregarParceiros() async {
    String jsonData = await rootBundle.loadString('json/parceiros.json');
    setState(() {
      parceiros = jsonDecode(jsonData);
    });
  }

  void mostrarDetalhesParceiro(Map<String, dynamic> parceiro) {
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
                  parceiro['nome'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Image.asset(parceiro['imagem'], width: 300, height: 200, fit: BoxFit.cover),
                SizedBox(height: 10),
                Text(
                  parceiro['descricao'],
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
    Color appBarColor = Color(0xFFFFCD69);
    Color borderColor = Color(0xFFFFA22B);

    return Scaffold(
      appBar: AppBar(
        title: Text("Parceiros"),
        backgroundColor: appBarColor,
        shape: Border(
          bottom: BorderSide(color: borderColor, width: 3),
        ),
      ),
      body: Container(
        color: Color(0xFFFFF0CF),
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
                  itemCount: parceiros.length,
                  itemBuilder: (context, index) {
                    final parceiro = parceiros[index];
                    return GestureDetector(
                      onTap: () => mostrarDetalhesParceiro(parceiro),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.asset(parceiro['imagem'], fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                parceiro['nome'],
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
            top: BorderSide(color: Color(0xFFFFA22B), width: 5),
            right: BorderSide(color: Color(0xFFFFA22B), width: 5),
            left: BorderSide(color: Color(0xFFFFA22B), width: 5),
            bottom: BorderSide(color: Color(0xFFFFA22B), width: 5),
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
