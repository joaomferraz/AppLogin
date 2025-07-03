import 'package:flutter/material.dart';
import 'dart:collection'; // Importe para usar o LinkedHashMap
import '../models/user_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../database/event_dao.dart';
import '../database/recurring_event_dao.dart';
import 'add_recurring_event_screen.dart';
import 'edit_event_screen.dart';

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

  void _showEventActionsDialog(EventModel event) {
    // Se é um evento gerado por uma regra recorrente
    if (event.recurringRuleId != null) {
      _showRecurringEventActionsDialog(event.recurringRuleId!, event.title);
    } 
    // Se é um evento único, salvo no banco
    else if (event.id != null) {
      _showSingleEventActionsDialog(event);
    }
  }

  void _showSingleEventActionsDialog(EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: const Text('O que você gostaria de fazer com este evento?'),
        actions: [
          TextButton(
            child: const Text('Excluir'),
            onPressed: () async {
              Navigator.pop(context); // Fecha o diálogo de ações
              
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar Exclusão'),
                  content: const Text('Você tem certeza que deseja excluir este evento?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Excluir')),
                  ],
                ),
              );

              if (confirm == true) {
                await EventDao.deleteEvent(event.id!);
                _loadEventsForMonth(_focusedDay); // Atualiza o calendário
              }
            },
          ),
          TextButton(
            child: const Text('Editar'),
            onPressed: () async {
              Navigator.pop(context); // Fecha o diálogo de ações
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => EditEventScreen(event: event)),
              );
              if (result == true) {
                _loadEventsForMonth(_focusedDay); // Atualiza o calendário
              }
            },
          ),
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showRecurringEventActionsDialog(int ruleId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Este é um evento recorrente. A ação afetará todas as ocorrências.'),
        actions: [
          TextButton(
            child: const Text('Excluir Regra'),
              onPressed: () async {
                Navigator.pop(context); // Fecha o diálogo de ações

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar Exclusão'),
                    content: const Text('Você tem certeza? A regra e todas as suas repetições serão excluídas permanentemente.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Excluir Tudo')),
                    ],
                  ),
                );

                if (confirm == true) {
                  await RecurringEventDao.deleteRecurringEvent(ruleId);
                  _loadEventsForMonth(_focusedDay); // Atualiza o calendário
                }
              },
          ),
          // BOTÃO DE EDITAR ATUALIZADO
          TextButton(
            child: const Text('Editar Regra'),
            onPressed: () async {
              Navigator.pop(context); // Fecha o diálogo primeiro

              // 1. Busca os dados completos da regra no banco
              final eventToEdit = await RecurringEventDao.getRecurringEventById(ruleId);

              if (eventToEdit != null && mounted) {
                // 2. Navega para a tela, passando o objeto para edição
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddRecurringEventScreen(eventToEdit: eventToEdit),
                  ),
                );

                // 3. Se a edição foi salva, atualiza o calendário
                if (result == true) {
                  _loadEventsForMonth(_focusedDay);
                }
              }
            },
          ),
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _loadEventsForMonth(DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final newEvents = LinkedHashMap<DateTime, List<EventModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    // 1. CARREGA OS EVENTOS NORMAIS (como antes)
    final singleEvents = await EventDao.getEventsForMonth(month);
    for (final event in singleEvents) {
      final day = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (newEvents[day] == null) {
        newEvents[day] = [];
      }
      newEvents[day]!.add(event);
    }

    // 2. PARTE NOVA: PROCESSA OS EVENTOS RECORRENTES
    final recurringRules = await RecurringEventDao.getAllRecurringEvents();

    // Itera por cada dia do mês visível no calendário
    for (var day = firstDay; day.isBefore(lastDay.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      // Para cada dia, verifica todas as regras de recorrência
      for (final rule in recurringRules) {
        // A regra é válida para este dia?
        if (day.weekday == rule.daysOfWeek.firstWhere((d) => d == day.weekday, orElse: () => -1) &&
            (day.isAfter(rule.startDate) || isSameDay(day, rule.startDate)) &&
            (day.isBefore(rule.endDate) || isSameDay(day, rule.endDate))) {
              
          // Se sim, cria um EventModel "virtual" para este dia
          final recurringInstance = EventModel(title: rule.title, date: day, recurringRuleId: rule.id,);
          final dayUtc = DateTime.utc(day.year, day.month, day.day);
          
          if (newEvents[dayUtc] == null) {
            newEvents[dayUtc] = [];
          }
          newEvents[dayUtc]!.add(recurringInstance);
        }
      }
    }

    setState(() {
      _events = newEvents;
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
              headerStyle: const HeaderStyle(
                titleCentered: true, 
                formatButtonVisible: false, 
              ),
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
                      final event = value[index];
                      return ListTile(
                        title: Text(event.title),
                        // Adiciona um ícone para indicar que é clicável
                        trailing: const Icon(Icons.more_vert),
                        onTap: () {
                          // ABRIR O DIÁLOGO DE AÇÕES
                          _showEventActionsDialog(event);
                        },
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navega para a tela de cadastro
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddRecurringEventScreen()),
          );

          // Se o resultado for 'true', significa que um novo evento foi salvo.
          // Então, recarregamos os eventos para atualizar o calendário.
          if (result == true) {
            _loadEventsForMonth(_focusedDay);
          }
        },
      ),
    );
  }
}