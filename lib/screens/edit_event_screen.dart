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

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados do evento existente
    _titleController = TextEditingController(text: widget.event.title);
    _selectedDate = widget.event.date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveChanges() {
    if (_titleController.text.isEmpty) {
      // Adicionar feedback se necessário
      return;
    }

    final updatedEvent = EventModel(
      id: widget.event.id, // MANTÉM O ID ORIGINAL
      title: _titleController.text,
      date: _selectedDate,
    );

    EventDao.updateEvent(updatedEvent).then((_) {
      if (mounted) {
        Navigator.pop(context, true); // Retorna true para indicar sucesso
      }
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
                Expanded(child: Text('Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}')),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Alterar Data'),
                ),
              ],
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
