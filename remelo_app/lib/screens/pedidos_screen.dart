import 'package:flutter/material.dart';
import 'pedido_service.dart';
import 'pedido_detalle_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  late Future<List<Map<String, dynamic>>> _futurePedidos;

  @override
  void initState() {
    super.initState();
    _futurePedidos = PedidoService.obtenerPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder(
        future: _futurePedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error cargando pedidos.'));
          }

          final pedidos = snapshot.data!;

          if (pedidos.isEmpty) {
            return const Center(child: Text('No tienes pedidos aún.'));
          }

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];

              return ListTile(
                title: Text('Pedido #${pedido['id']}'),
                subtitle: Text('Estado: ${pedido['status']['nombre']}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PedidoDetalleScreen(pedido: {
                        'id': pedido['id'],
                        'estado': pedido['status']['nombre'],
                        'fecha': pedido['created_at'],
                        'total': pedido['total'] ?? 'N/A'
                      }),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
