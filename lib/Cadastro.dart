import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Para acessar o diretório de documentos

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _email = '';
  String _senha = '';
  File? _imageFile;

  // Função para escolher a imagem
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Função para salvar os dados no cadastro.json
  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Criando os dados de perfil
      Map<String, dynamic> perfilData = {
        'nome': _nome,
        'email': _email,
        'senha': _senha,
        'foto': _imageFile?.path ?? '',
      };

      // Salvando o perfil em um arquivo JSON
      final directory = await getApplicationDocumentsDirectory(); // Diretório persistente
      final file = File('${directory.path}/cadastro.json');

      // Verifica se o arquivo já existe
      List<dynamic> cadastros = [];
      if (await file.exists()) {
        String content = await file.readAsString();
        cadastros = json.decode(content);
      }

      // Adiciona o novo cadastro à lista
      cadastros.add(perfilData);

      // Salva a lista atualizada no arquivo
      await file.writeAsString(json.encode(cadastros));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      // Limpa o formulário após o cadastro
      _formKey.currentState?.reset();
      setState(() {
        _imageFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text("Cadastro"),
        backgroundColor: Color(0xFF56CCF2),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildImagePicker(),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField("Nome", (value) => _nome = value),
                  SizedBox(height: 10),
                  _buildTextField("Email", (value) => _email = value),
                  SizedBox(height: 10),
                  _buildTextField("Senha", (value) => _senha = value, obscureText: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text("Cadastrar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar o campo de texto
  Widget _buildTextField(String label, Function(String) onChanged, {bool obscureText = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label é obrigatório';
        }
        return null;
      },
    );
  }

  // Função para exibir o botão de escolha de imagem
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Color(0xFF56CCF2),
        child: _imageFile == null
            ? Icon(Icons.camera_alt, color: Colors.white)
            : ClipOval(child: Image.file(_imageFile!, fit: BoxFit.cover, width: 100, height: 100)),
      ),
    );
  }
}