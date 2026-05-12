import 'package:flutter/material.dart';

class WrittenModeScreen extends StatefulWidget {
  final String deckTitle;

  const WrittenModeScreen({super.key, required this.deckTitle});

  @override
  State<WrittenModeScreen> createState() => _WrittenModeScreenState();
}

class _WrittenModeScreenState extends State<WrittenModeScreen> {
  int _currentIndex = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  final TextEditingController _textController = TextEditingController();

  // Dummy data con respuestas de una sola palabra para facilitar la escritura y comprobacion
  final Map<String, List<Map<String, String>>> _deckData = {
    'Anatomía Humana': [
      {'q': '¿Qué orgánulo produce energía en la célula?', 'a': 'Mitocondria'},
      {'q': '¿Qué hueso es el más largo del cuerpo humano?', 'a': 'Fémur'},
      {'q': '¿Qué órgano del cuerpo humano es responsable de bombear la sangre?', 'a': 'Corazón'},
      {'q': '¿Qué órganos del sistema respiratorio se encargan de obtener el oxígeno?', 'a': 'Pulmones'},
    ],
    'Vocabulario Inglés': [
      {'q': 'Traduce al español: "Dog"', 'a': 'Perro'},
      {'q': 'Traduce al español: "Book"', 'a': 'Libro'},
      {'q': 'Traduce al español: "Apple"', 'a': 'Manzana'},
      {'q': 'Traduce al español: "Cat"', 'a': 'Gato'},
    ],
    'Constitución Española': [
      {'q': '¿En qué año se aprobó la Constitución Española?', 'a': '1978'},
      {'q': '¿Cuál es la forma política del Estado español?', 'a': 'Monarquía parlamentaria'},
      {'q': '¿Quién es el jefe del Estado en España?', 'a': 'Rey'},
      {'q': '¿Cuál es la lengua oficial del Estado español?', 'a': 'Castellano'},
    ],
  };

  List<Map<String, String>> get _currentCards {
    return _deckData[widget.deckTitle] ?? _deckData['Prueba']!;
  }

  // Normaliza el texto a minúsculas y sin acentos para evitar errores
  String _normalizeString(String input) {
    String normalized = input.trim().toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'[áäâà]'), 'a');
    normalized = normalized.replaceAll(RegExp(r'[éëêè]'), 'e');
    normalized = normalized.replaceAll(RegExp(r'[íïîì]'), 'i');
    normalized = normalized.replaceAll(RegExp(r'[óöôò]'), 'o');
    normalized = normalized.replaceAll(RegExp(r'[úüûù]'), 'u');
    return normalized;
  }

  void _checkAnswer() {
    if (_textController.text.trim().isEmpty) return;

    String userAnswer = _normalizeString(_textController.text);
    String correctAnswer = _normalizeString(_currentCards[_currentIndex]['a']!);

    setState(() {
      _isCorrect = (userAnswer == correctAnswer);
      _showResult = true;
    });
  }

  void _nextCard() {
    setState(() {
      if (_currentIndex < _currentCards.length - 1) {
        _currentIndex++;
        _showResult = false;
        _textController.clear();
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalCards = _currentCards.length;
    Map<String, String> currentCard = _currentCards[_currentIndex];
    double progress = (_currentIndex) / totalCards;

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
            value: progress,
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
            // Contenedor de la pregunta
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5)),
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
                    const SizedBox(height: 40),
                    
                    // Input de texto
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: _textController,
                        enabled: !_showResult, // Bloquea el campo si ya se comprobó
                        autofocus: true,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Escribe tu respuesta...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _checkAnswer(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // Feedback visual y botón inferior
            if (_showResult) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _isCorrect ? Colors.green : Colors.red),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isCorrect ? Icons.check_circle : Icons.cancel, color: _isCorrect ? Colors.green : Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          _isCorrect ? '¡Correcto!' : 'Incorrecto',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _isCorrect ? Colors.green.shade700 : Colors.red.shade700),
                        ),
                      ],
                    ),
                    if (!_isCorrect) ...[
                      const SizedBox(height: 8),
                      Text(
                        'La respuesta era: ${currentCard['a']}',
                        style: TextStyle(color: Colors.red.shade800, fontSize: 16),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nextCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCorrect ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('SIGUIENTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('COMPROBAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}