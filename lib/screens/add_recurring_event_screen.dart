// screens/add_recurring_event_screen.dart

import 'package:flutter/material.dart';
import '../models/recurring_event_model.dart';
import '../database/recurring_event_dao.dart';

class AddRecurringEventScreen extends StatefulWidget {
  // NOVO: Parâmetro opcional para receber o evento a ser editado
  final RecurringEventModel? eventToEdit;

  const AddRecurringEventScreen({super.key, this.eventToEdit});

  @override
  _AddRecurringEventScreenState createState() =>
      _AddRecurringEventScreenState();
}

class _AddRecurringEventScreenState extends State<AddRecurringEventScreen> {
  final _titleController = TextEditingController();
  late DateTime _startDate;
  late DateTime _endDate;
  late Map<int, bool> _selectedDays;
  late bool _isEditMode; // NOVO: Flag para saber se estamos em modo de edição

  final Map<int, String> _dayLabels = {
    DateTime.monday: 'Seg',
    DateTime.tuesday: 'Ter',
    DateTime.wednesday: 'Qua',
    DateTime.thursday: 'Qui',
    DateTime.friday: 'Sex',
    DateTime.saturday: 'Sáb',
    DateTime.sunday: 'Dom',
  };
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.eventToEdit != null;

    // Se estiver em modo de edição, preenche os campos com os dados existentes
    if (_isEditMode) {
      final event = widget.eventToEdit!;
      _titleController.text = event.title;
      _startDate = event.startDate;
      _endDate = event.endDate;
      _selectedDays = { for (var day in _dayLabels.keys) day: event.daysOfWeek.contains(day) };
    } 
    // Senão, inicializa como antes (modo de adição)
    else {
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 30));
      _selectedDays = { for (var day in _dayLabels.keys) day: false };
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }
  
  void _saveEvent() {
    final title = _titleController.text;
    final selectedDaysList = _selectedDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (title.isEmpty || selectedDaysList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o título e selecione pelo menos um dia.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ALTERADO: Lógica para decidir entre ATUALIZAR ou INSERIR
    if (_isEditMode) {
      final updatedEvent = RecurringEventModel(
        id: widget.eventToEdit!.id, // Mantém o ID original
        title: title,
        startDate: _startDate,
        endDate: _endDate,
        daysOfWeek: selectedDaysList,
      );
      RecurringEventDao.updateRecurringEvent(updatedEvent).then((_) {
        if (mounted) Navigator.pop(context, true);
      });
    } else {
      final newRecurringEvent = RecurringEventModel(
        title: title,
        startDate: _startDate,
        endDate: _endDate,
        daysOfWeek: selectedDaysList,
      );
      RecurringEventDao.insertRecurringEvent(newRecurringEvent).then((_) {
        if (mounted) Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ALTERADO: Título dinâmico
      appBar: AppBar(title: Text(_isEditMode ? 'Editar Evento Recorrente' : 'Adicionar Evento Recorrente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título (ex: Academia, Cálculo I)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Repetir nos dias:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: _dayLabels.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: _selectedDays[entry.key]!,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDays[entry.key] = selected;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Data de Início'),
                    TextButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text('${_startDate.day}/${_startDate.month}/${_startDate.year}'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Data de Fim'),
                    TextButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text('${_endDate.day}/${_endDate.month}/${_endDate.year}'),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              // ALTERADO: Texto do botão dinâmico
              child: Text(_isEditMode ? 'Salvar Alterações' : 'Salvar Evento Recorrente'),
            ),
          ],
        ),
      ),
    );
  }
}