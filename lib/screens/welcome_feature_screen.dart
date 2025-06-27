import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../database/event_dao.dart';

class WelcomeFeatureScreen extends StatefulWidget {
  final UserModel user;

  const WelcomeFeatureScreen({super.key, required this.user});

  @override
  _WelcomeFeatureScreenState createState() => _WelcomeFeatureScreenState();
}

class _WelcomeFeatureScreenState extends State<WelcomeFeatureScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, List<EventModel>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = {};
    _loadEvents();
  }

  // Função para carregar eventos do banco de dados
  Future<void> _loadEvents() async {
    final events = await EventDao.getEventsByDate(_selectedDay);
    setState(() {
      _events[_selectedDay] = events;
    });
  }

  // Função para carregar eventos para o dia selecionado
  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  // Função para adicionar evento
  void _addEvent(DateTime day) {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Evento'),
          content: TextField(
            controller: eventController,
            decoration: const InputDecoration(hintText: 'Digite o evento'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (eventController.text.isNotEmpty) {
                  final newEvent = EventModel(
                    title: eventController.text,
                    date: day,
                  );
                  await EventDao.insertEvent(newEvent); // Salva o evento no banco
                  _loadEvents(); // Recarrega os eventos para o dia selecionado
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo sem adicionar evento
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendário
            TableCalendar<EventModel>(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _loadEvents();
                });
              },
              eventLoader: _getEventsForDay,
            ),
            const SizedBox(height: 20),
            // Exibição dos eventos do dia selecionado
            Expanded(
              child: ListView(
                children: _getEventsForDay(_selectedDay).map((event) {
                  return ListTile(
                    title: Text(event.title),
                  );
                }).toList(),
              ),
            ),
            // Botão para adicionar evento
            ElevatedButton(
              onPressed: () => _addEvent(_selectedDay),
              child: const Text('Adicionar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}