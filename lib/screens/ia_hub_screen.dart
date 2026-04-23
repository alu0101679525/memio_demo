import 'package:flutter/material.dart';

class IaHubScreen extends StatefulWidget {
  const IaHubScreen({super.key});

  @override
  State<IaHubScreen> createState() => _IaHubScreenState();
}

class _IaHubScreenState extends State<IaHubScreen> {
  String selectedSource = 'TEXTO';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FUENTE DE ENTRADA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          
          // Selector de fuentes (Iconos superiores)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSourceOption('TEXTO', Icons.notes_rounded),
              _buildSourceOption('IMAGEN', Icons.image_outlined),
              _buildSourceOption('ENLACE', Icons.link_rounded),
              _buildSourceOption('VIDEO', Icons.play_circle_outline),
            ],
          ),
          const SizedBox(height: 24),

          // Área de entrada principal
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Pega tu texto aquí o describe lo que quieres aprender...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Configuración (Tarjetas y Dificultad)
          _buildDropdownOption('Número de tarjetas', '10'),
          const SizedBox(height: 16),
          _buildDropdownOption('Dificultad', 'Media'),
          
          const SizedBox(height: 32),

          // Botón Generar con coste de créditos
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'GENERAR TARJETAS',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '- 5 créditos',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          // Info del modelo
          const Center(
            child: Text(
              'Usando GPT-4.1 mini para el procesamiento',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para las opciones de fuente (Texto, Imagen, etc.)
  Widget _buildSourceOption(String label, IconData icon) {
    bool isSelected = selectedSource == label;
    return GestureDetector(
      onTap: () => setState(() => selectedSource = label),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1D4ED8) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade400, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF1D4ED8) : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para los selectores de configuración
  Widget _buildDropdownOption(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}