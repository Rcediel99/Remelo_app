import 'package:flutter/material.dart';

class PedidoDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> pedido;

  const PedidoDetalleScreen({super.key, required this.pedido});

  Color _estadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'en camino':
        return Colors.orange;
      case 'entregado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorEstado = _estadoColor(pedido['estado']);

    return Scaffold(
      appBar: AppBar(title: Text('Pedido #${pedido['id']}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${pedido['fecha']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Estado: ', style: TextStyle(fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorEstado.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pedido['estado'],
                    style: TextStyle(
                      color: colorEstado,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Total pagado: \$${pedido['total']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Resumen del pedido:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text('- Camiseta básica negra (Talla M)'),
            const Text('- Envío estándar'),
            const Text('- Pago con tarjeta'),
          ],
        ),
      ),
    );
  }
}
