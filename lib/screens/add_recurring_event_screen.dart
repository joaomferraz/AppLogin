import 'package:flutter/material.dart';
import '../models/recurring_event_model.dart';
import '../database/recurring_event_dao.dart';

class AddRecurringEventScreen extends StatefulWidget {
  const AddRecurringEventScreen({super.key});

  @override
  _AddRecurringEventScreenState createState() =>
      _AddRecurringEventScreenState();
}

class _AddRecurringEventScreenState extends State<AddRecurringEventScreen> {
  final _titleController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  final Map<int, bool> _selectedDays = {
    DateTime.monday: false,
    DateTime.tuesday: false,
    DateTime.wednesday: false,
    DateTime.thursday: false,
    DateTime.friday: false,
    DateTime.saturday: false,
    DateTime.sunday: false,
  };

  // Mudei para um mapa de String para ficar mais legível
  final Map<int, String> _dayLabels = {
    DateTime.monday: 'Seg',
    DateTime.tuesday: 'Ter',
    DateTime.wednesday: 'Qua',
    DateTime.thursday: 'Qui',
    DateTime.friday: 'Sex',
    DateTime.saturday: 'Sáb',
    DateTime.sunday: 'Dom',
  };

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
      // ✅ FEEDBACK ADICIONADO
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o título e selecione pelo menos um dia.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newRecurringEvent = RecurringEventModel(
      title: title,
      startDate: _startDate,
      endDate: _endDate,
      daysOfWeek: selectedDaysList,
    );

    RecurringEventDao.insertRecurringEvent(newRecurringEvent).then((_) {
      // Agora o pop vai funcionar, pois o insert não dará mais erro.
      if (mounted) {
        Navigator.pop(context, true); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Evento Recorrente')),
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
            // ✅ CORRIGIDO: `Row` trocada por `Wrap` para evitar overflow
            Wrap(
              spacing: 8.0, // Espaçamento horizontal
              runSpacing: 4.0, // Espaçamento vertical
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
              child: const Text('Salvar Evento Recorrente'),
            ),
          ],
        ),
      ),
    );
  }
}