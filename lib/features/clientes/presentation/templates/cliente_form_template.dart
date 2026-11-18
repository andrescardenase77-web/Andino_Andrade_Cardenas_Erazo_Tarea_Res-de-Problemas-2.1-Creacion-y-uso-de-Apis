import 'package:flutter/material.dart';
import '../../domain/entities/cliente.dart';

class ClienteFormTemplate extends StatefulWidget {
  final bool loading;
  final Future<void> Function(Cliente cliente) onSubmit;

  const ClienteFormTemplate({
    super.key,
    required this.onSubmit,
    this.loading = false,
  });

  @override
  State<ClienteFormTemplate> createState() => _ClienteFormTemplateState();
}

class _ClienteFormTemplateState extends State<ClienteFormTemplate> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSubmit(Cliente(
      nombre: _nombre.text.trim(),
      telefono: _telefono.text.trim(),
      email: _email.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Puedes reemplazar TextFormField por CustomTextField y
    // ElevatedButton por CustomButton de core_ui/atoms.
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nombre,
            decoration: const InputDecoration(labelText: 'Nombre'),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _telefono,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo'),
            validator: _required,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.loading ? null : _submit,
            child: widget.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Registrar cliente'),
          ),
        ],
      ),
    );
  }
}