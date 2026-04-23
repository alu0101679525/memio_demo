import 'package:flutter/material.dart';

class IaHubScreen extends StatefulWidget {
  const IaHubScreen({super.key});

  @override
  State<IaHubScreen> createState() => _IaHubScreenState();
}

class _IaHubScreenState extends State<IaHubScreen> {
  String selectedSource = 'TEXTO';
  int selectedCards = 10;
  String selectedDifficulty = 'Baja';

  // Opciones para los desplegables
  final List<int> cardOptions = List.generate(10, (index) => (index + 1) * 5); // 5 a 50
  final List<String> difficultyOptions = ['Baja', 'Media', 'Alta'];

  // Lógica de créditos: 1 crédito cada 2 tarjetas (redondeando hacia arriba)
  int get creditCost => (selectedCards / 2).ceil();

  String _getHintText() {
    switch (selectedSource) {
      case 'ENLACE': return 'Pega el enlace de la web o artículo aquí...';
      case 'VIDEO': return 'Pega la URL del vídeo aquí...';
      default: return 'Pega tu texto aquí o describe lo que quieres aprender...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FUENTE DE ENTRADA',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
          ),
          const SizedBox(height: 16),
          
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

          // Área de entrada (texto/imagen)
          if (selectedSource == 'IMAGEN')
            _buildImageUploadPlaceholder()
          else
            _buildTextFieldArea(),
          
          const SizedBox(height: 24),

          // Configuración desplegables
          _buildDropdownContainer(
            label: 'Número de tarjetas',
            child: DropdownButton<int>(
              value: selectedCards,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              onChanged: (int? newValue) => setState(() => selectedCards = newValue!),
              items: cardOptions.map((int value) => DropdownMenuItem(
                value: value, 
                child: Text('$value', style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildDropdownContainer(
            label: 'Dificultad',
            child: DropdownButton<String>(
              value: selectedDifficulty,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              onChanged: (String? newValue) => setState(() => selectedDifficulty = newValue!),
              items: difficultyOptions.map((String value) => DropdownMenuItem(
                value: value, 
                child: Text(value, style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 32),

          // Botón Generar Tarjetas
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Generando $selectedCards tarjetas de dificultad $selectedDifficulty...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('GENERAR TARJETAS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '- $creditCost créditos',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          Center(child: Text('Usando GPT-4.1 mini para el procesamiento', style: const TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  // Contenedor para los desplegables
  Widget _buildDropdownContainer({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          SizedBox(width: 60, child: child),
        ],
      ),
    );
  }

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
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF1D4ED8) : Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _buildTextFieldArea() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(hintText: _getHintText(), hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14), border: InputBorder.none),
      ),
    );
  }

  Widget _buildImageUploadPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.blue.shade600),
          const SizedBox(height: 12),
          const Text('Haz click para insertar una imagen', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}