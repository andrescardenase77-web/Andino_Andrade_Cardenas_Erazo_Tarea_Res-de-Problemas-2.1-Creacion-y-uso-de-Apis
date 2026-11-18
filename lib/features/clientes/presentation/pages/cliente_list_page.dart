import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../organisms/cliente_list_item.dart';
import '../templates/cliente_form_template.dart';
import '../viewmodels/cliente_viewmodel.dart';

class ClienteListPage extends StatefulWidget {
  const ClienteListPage({super.key});

  @override
  State<ClienteListPage> createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<ClienteListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ClienteViewModel>().loadClientes(),
    );
  }

  void _openForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Consumer<ClienteViewModel>(
          builder: (_, vm, __) => ClienteFormTemplate(
            loading: vm.loading,
            onSubmit: (cliente) async {
              final ok = await vm.registrar(cliente);
              if (!ctx.mounted) return;
              if (ok) {
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(vm.error ?? 'Error')),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClienteViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        child: const Icon(Icons.person_add),
      ),
      body: vm.loading && vm.clientes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null && vm.clientes.isEmpty
              ? Center(child: Text(vm.error!))
              : RefreshIndicator(
                  onRefresh: vm.loadClientes,
                  child: ListView.builder(
                    itemCount: vm.clientes.length,
                    itemBuilder: (_, i) =>
                        ClienteListItem(cliente: vm.clientes[i]),
                  ),
                ),
    );
  }
}