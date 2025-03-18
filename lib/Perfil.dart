import 'package:flutter/material.dart';
import 'dart:io';

class PerfilScreen extends StatelessWidget {
  final Map<String, dynamic> perfil;

  PerfilScreen({required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de ${perfil['nome']}"),
        backgroundColor: Color(0xFFCBE558),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto do Usuário
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: perfil['foto'] != null && perfil['foto'].isNotEmpty
                    ? FileImage(File(perfil['foto']))
                    : AssetImage('assets/placeholder.jpg') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),

            // Nome do Usuário
            Text("Nome: ${perfil['nome']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Email: ${perfil['email']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SizedBox(height: 20),

            // Listando as Reservas
            Text("Minhas Reservas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            perfil['reservas'] == null || perfil['reservas'].isEmpty
                ? Text("Você não tem reservas.")
                : ListView.builder(
              shrinkWrap: true,
              itemCount: perfil['reservas'].length,
              itemBuilder: (context, index) {
                var reserva = perfil['reservas'][index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Destino: ${reserva['destino']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("Data de Ida: ${reserva['dataIda']}", style: TextStyle(fontSize: 14)),
                        Text("Data de Volta: ${reserva['dataVolta']}", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}