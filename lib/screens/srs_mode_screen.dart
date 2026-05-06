import 'package:flutter/material.dart';

class SrsModeScreen extends StatefulWidget {
  final String deckTitle;

  const SrsModeScreen({super.key, required this.deckTitle});

  @override
  State<SrsModeScreen> createState() => _SrsModeScreenState();
}

class _SrsModeScreenState extends State<SrsModeScreen> {
  bool _showAnswer = false;
  int _currentIndex = 0;

  // Dummy data con listas de preguntas según el mazo
  final Map<String, List<Map<String, String>>> _deckData = {
    'Anatomía Humana': [
      {'q': '¿Cuál es la función principal de las mitocondrias en la célula?', 'a': 'Producción de energía química en forma de ATP mediante la respiración celular.'},
      {'q': '¿Qué hueso es el más largo del cuerpo humano?', 'a': 'El fémur.'},
      {'q': '¿Qué órgano del cuerpo humano es responsable de bombear la sangre?', 'a': 'El corazón.'},
      {'q': '¿Qué órganos del sistema respiratorio se encargan de obtener el oxígeno?', 'a': 'Los pulmones.'},
    ],
    'Vocabulario Inglés': [
      {'q': 'Perro', 'a': 'Dog'},
      {'q': 'Libro', 'a': 'Book'},
      {'q': 'Manzana', 'a': 'Apple'},
      {'q': 'Gato', 'a': 'Cat'},
    ],
    'Constitución Española': [
      {'q': '¿En qué año se aprobó la Constitución Española?', 'a': 'En 1978'},
      {'q': '¿Cuál es la forma política del Estado español?', 'a': 'La Monarquía parlamentaria.'},
      {'q': '¿Quién es el jefe del Estado en España?', 'a': 'El Rey.'},
      {'q': '¿Cuál es la lengua oficial del Estado español?', 'a': 'El castellano.'},
    ],
  };

  // Obtener las tarjetas del mazo actual (si no existe, carga unas por defecto)
  List<Map<String, String>> get _currentCards {
    return _deckData[widget.deckTitle] ?? [{'q': 'Pregunta de prueba', 'a': 'Respuesta de prueba'}];
  }

  void _nextCard() {
    setState(() {
      if (_currentIndex < _currentCards.length - 1) {
        _currentIndex++;
        _showAnswer = false; // Ocultar respuesta para la nueva tarjeta
      } else {
        // TODO: Mostrar pantalla de resumen al terminar
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalCards = _currentCards.length;
    Map<String, String> currentCard = _currentCards[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.deckTitle.toUpperCase(),
                style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${_currentIndex + 1} / $totalCards',
              style: const TextStyle(color: Color(0xFF1D4ED8), fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / totalCards,
            backgroundColor: Colors.grey.shade100,
            color: const Color(0xFF1D4ED8),
            minHeight: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Tarjeta principal
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('PREGUNTA', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                    const SizedBox(height: 20),
                    Text(
                      currentCard['q']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87, height: 1.3),
                    ),
                    
                    if (_showAnswer) ...[
                      const SizedBox(height: 30),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 30),
                      const Text('RESPUESTA', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                      const SizedBox(height: 20),
                      Text(
                        currentCard['a']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1.4),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // Controles inferiores
            if (!_showAnswer)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => setState(() => _showAnswer = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('MOSTRAR RESPUESTA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              )
            else
              Column(
                children: [
                  const Text('¿QUÉ TAN FÁCIL FUE?', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDifficultyButton('Difícil', '< 10 min', Colors.red.shade50, Colors.red.shade700),
                      _buildDifficultyButton('Bien', '3 días', Colors.blue.shade50, Colors.blue.shade700),
                      _buildDifficultyButton('Fácil', '5 días', Colors.green.shade50, Colors.green.shade700),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String label, String timeText, Color bgColor, Color textColor) {
    return GestureDetector(
      onTap: _nextCard,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(timeText, style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}