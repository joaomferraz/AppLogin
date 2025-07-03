import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../database/event_dao.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;

  const EditEventScreen({super.key, required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isAllDay = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _selectedDate = widget.event.date;
    _selectedTime = widget.event.time;
    _isAllDay = widget.event.isAllDay;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveChanges() {
    if (_titleController.text.isEmpty) return;

    final updatedEvent = EventModel(
      id: widget.event.id,
      title: _titleController.text,
      date: _selectedDate,
      time: _isAllDay ? null : _selectedTime,
      isAllDay: _isAllDay,
    );

    EventDao.updateEvent(updatedEvent).then((_) {
      if (mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: Text('Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}')),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Alterar Data'),
                ),
              ],
            ),
            CheckboxListTile(
              value: _isAllDay,
              onChanged: (value) => setState(() => _isAllDay = value!),
              title: const Text('Evento o dia inteiro'),
            ),
            if (!_isAllDay)
              TextButton(
                onPressed: () => _selectTime(context),
                child: Text(_selectedTime == null
                    ? 'Selecionar Horário'
                    : 'Horário: ${_selectedTime!.format(context)}'),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
