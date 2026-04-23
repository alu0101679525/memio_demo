import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dummy data para los mazos
  final List<Map<String, dynamic>> _decks = [
    {
      'title': 'Anatomía Humana',
      'progress': 0.65,
      'color': Colors.blue.shade600,
      'newCards': 12,
    },
    {
      'title': 'Vocabulario Inglés',
      'progress': 0.40,
      'color': Colors.green.shade500,
      'newCards': 25,
    },
    {
      'title': 'Constitución Española',
      'progress': 0.15,
      'color': Colors.orange.shade500,
      'newCards': 50,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Mensaje de bienvenida
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(text: 'Hola, '),
                  TextSpan(
                    text: 'Estudiante',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '. \nTienes 3 mazos pendientes para hoy.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de mazos
            Expanded(
              child: ListView.builder(
                itemCount: _decks.length,
                itemBuilder: (context, index) {
                  return _buildDeckCard(_decks[index]);
                },
              ),
            ),
          ],
        ),
      ),
      // Botón flotante (+)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1D4ED8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          // TODO: Acción para añadir nuevo mazo
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Widget personalizado para cada tarjeta de mazo
  Widget _buildDeckCard(Map<String, dynamic> deck) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deck['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: deck['progress'],
              backgroundColor: Colors.grey.shade100,
              color: deck['color'],
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          // Texto descriptivo inferior
          Text(
            '${(deck['progress'] * 100).toInt()}% Dominado • ${deck['newCards']} tarjetas nuevas',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}