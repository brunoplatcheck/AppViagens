import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Login.dart'; // Importe a tela de login
import 'cadastro.dart'; // Importe a tela de cadastro

class Reservas extends StatefulWidget {
  final String? nomeUsuario; // Nome do usuário logado (pode ser nulo)

  Reservas({this.nomeUsuario});

  @override
  State<Reservas> createState() => _ReservasState();
}

class _ReservasState extends State<Reservas> {
  DateTime? dataIda;
  DateTime? dataVolta;
  String? destinoSelecionado;
  String? _nomeUsuario; // Variável local para armazenar o nome do usuário

  Map<DateTime, bool> reservas = {};
  DateTime _focusedDay = DateTime.now();

  List<Map<String, dynamic>> destinos = [];

  @override
  void initState() {
    super.initState();
    _nomeUsuario = widget.nomeUsuario; // Inicializa com o valor passado pelo widget
    carregarDestinos();
  }

  Future<void> carregarDestinos() async {
    String jsonData = await rootBundle.loadString('json/destinos.json');
    setState(() {
      destinos = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
    });
  }

  Future<void> _salvarReserva() async {
    // Verifica se o usuário está logado
    if (_nomeUsuario == null) {
      _exibirModalLoginCadastro(); // Redireciona para login/cadastro
      return;
    }

    // Verifica se todos os campos estão preenchidos
    if (dataIda == null || dataVolta == null || destinoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preencha todos os campos!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (dataIda!.isAfter(dataVolta!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("A data de ida deve ser anterior à data de volta!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Criar a reserva
    Map<String, dynamic> reserva = {
      'destino': destinoSelecionado,
      'dataIda': dataIda!.toIso8601String(),
      'dataVolta': dataVolta!.toIso8601String(),
    };

    // Salvar a reserva no cadastro do usuário
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/cadastro.json');

    if (await file.exists()) {
      String content = await file.readAsString();
      List<dynamic> cadastros = json.decode(content);

      // Encontrar o cadastro do usuário logado
      for (var cadastro in cadastros) {
        if (cadastro['nome'] == _nomeUsuario) {
          // Adicionar a reserva ao cadastro do usuário
          if (cadastro['reservas'] == null) {
            cadastro['reservas'] = [];
          }
          cadastro['reservas'].add(reserva);
          break;
        }
      }

      // Salvar o arquivo atualizado
      await file.writeAsString(json.encode(cadastros));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reserva salva com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nenhum cadastro encontrado!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _exibirModalLoginCadastro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Escolha uma opção"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final nomeUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cadastro()),
                  );
                  if (nomeUsuario != null) {
                    setState(() {
                      _nomeUsuario = nomeUsuario; // Atualiza a variável local
                    });
                  }
                },
                child: Text("Cadastrar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final nomeUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  if (nomeUsuario != null) {
                    setState(() {
                      _nomeUsuario = nomeUsuario; // Atualiza a variável local
                    });
                  }
                },
                child: Text("Login"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservas"),
        backgroundColor: Color(0xFFCBE558),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // DropdownButton para selecionar o destino
              DropdownButton<String>(
                value: destinoSelecionado,
                hint: Text("Selecione um destino"),
                isExpanded: true,
                items: destinos.map((destino) {
                  return DropdownMenuItem<String>(
                    value: destino['nome'],
                    child: Text(destino['nome']),
                  );
                }).toList(),
                onChanged: (String? novoDestino) {
                  setState(() {
                    destinoSelecionado = novoDestino;
                  });
                },
              ),
              SizedBox(height: 20),

              // Campos para selecionar as datas
              _buildDateInput("Data de Ida", (date) => setState(() => dataIda = date), dataIda),
              SizedBox(height: 20),
              _buildDateInput("Data de Volta", (date) => setState(() => dataVolta = date), dataVolta),
              SizedBox(height: 20),

              // Calendário
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                selectedDayPredicate: (day) {
                  return (dataIda != null && isSameDay(dataIda!, day)) ||
                      (dataVolta != null && isSameDay(dataVolta!, day));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                ),
                rangeStartDay: dataIda,
                rangeEndDay: dataVolta,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
              ),
              SizedBox(height: 20),

              // Botão de Reservar
              ElevatedButton(
                onPressed: _salvarReserva,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCBE558),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Reservar", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput(String label, Function(DateTime) onDateSelected, DateTime? selectedDate) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                  : "Selecione",
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
}