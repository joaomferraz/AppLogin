import 'package:flutter/material.dart';
import 'dart:collection'; // Importe para usar o LinkedHashMap
import '../models/user_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../database/event_dao.dart';

// Helper para o LinkedHashMap
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class WelcomeFeatureScreen extends StatefulWidget {
  final UserModel user;

  const WelcomeFeatureScreen({super.key, required this.user});

  @override
  _WelcomeFeatureScreenState createState() => _WelcomeFeatureScreenState();
}

class _WelcomeFeatureScreenState extends State<WelcomeFeatureScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  // Use um ValueNotifier para a lista de eventos do dia selecionado
  late final ValueNotifier<List<EventModel>> _selectedEvents;

  // Use um LinkedHashMap para agrupar todos os eventos do mês
  LinkedHashMap<DateTime, List<EventModel>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

    // Carrega os eventos para o mês inicial
    _loadEventsForMonth(_focusedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _loadEventsForMonth(DateTime month) async {
    final allEventsForMonth = await EventDao.getEventsForMonth(month);

    final newEvents = LinkedHashMap<DateTime, List<EventModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (final event in allEventsForMonth) {
      // Normaliza a data para meia-noite para evitar problemas com fuso horário
      final day = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (newEvents[day] == null) {
        newEvents[day] = [];
      }
      newEvents[day]!.add(event);
    }

    setState(() {
      _events = newEvents;
      // Atualiza a lista de eventos para o dia que já estava selecionado
      _selectedEvents.value = _getEventsForDay(_selectedDay);
    });
  }

  // Função para obter os eventos para um dia específico (do mapa já carregado)
  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      // Atualiza a lista de eventos do dia selecionado
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
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
                  // Recarrega os eventos para o mês inteiro para atualizar os marcadores
                  await _loadEventsForMonth(_focusedDay);
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
              locale: 'pt_BR', // Para o calendário ficar em português
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: _getEventsForDay, // Continua usando a mesma função
              // NOVA PROPRIEDADE: Carrega eventos quando o usuário muda de mês
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                _loadEventsForMonth(focusedDay);
              },
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
            ),
            const SizedBox(height: 20),
            // Exibição dos eventos do dia selecionado usando ValueListenableBuilder
            Expanded(
              child: ValueListenableBuilder<List<EventModel>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(value[index].title),
                      );
                    },
                  );
                },
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