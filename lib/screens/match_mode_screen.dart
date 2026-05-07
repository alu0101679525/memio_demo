import 'package:flutter/material.dart';

// Estados posibles de cada tarjeta en la sesión
enum CardState { normal, selected, matched, error }

class MatchCard {
  final String text;
  final String pairId;
  CardState state;

  MatchCard({required this.text, required this.pairId, this.state = CardState.normal});
}

class MatchModeScreen extends StatefulWidget {
  final String deckTitle;

  const MatchModeScreen({super.key, required this.deckTitle});

  @override
  State<MatchModeScreen> createState() => _MatchModeScreenState();
}

class _MatchModeScreenState extends State<MatchModeScreen> {
  // Hacemos dos columnas separadas
  final List<MatchCard> _leftColumn = [];
  final List<MatchCard> _rightColumn = [];
  
  MatchCard? _firstSelected;
  int _pairsFound = 0;
  int _totalPairs = 4;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Dummy data para en formato corto
    final Map<String, List<Map<String, String>>> deckData = {
      'Anatomía Humana': [
        {'q': 'Mitocondria', 'a': 'Energía'},
        {'q': 'Fémur', 'a': 'Pierna'},
        {'q': 'Corazón', 'a': 'Bombea sangre'},
        {'q': 'Pulmones', 'a': 'Oxígeno'},
      ],
      'Vocabulario Inglés': [
        {'q': 'Perro', 'a': 'Dog'},
        {'q': 'Libro', 'a': 'Book'},
        {'q': 'Manzana', 'a': 'Apple'},
        {'q': 'Gato', 'a': 'Cat'},
      ],
      'Constitución Española': [
        {'q': 'Aprobación', 'a': 'Año 1978'},
        {'q': 'Sistema', 'a': 'Monarquía parlamentaria'},
        {'q': 'Jefe del Estado', 'a': 'Rey'},
        {'q': 'Lengua oficial', 'a': 'Castellano'},
      ],
    };

    List<Map<String, String>> rawPairs = deckData[widget.deckTitle] ?? deckData['Prueba']!;
    _totalPairs = rawPairs.length;

    // Separamos en columna izquierda (preguntas) y derecha (respuestas)
    for (var i = 0; i < rawPairs.length; i++) {
      _leftColumn.add(MatchCard(text: rawPairs[i]['q']!, pairId: 'pair_$i'));
      _rightColumn.add(MatchCard(text: rawPairs[i]['a']!, pairId: 'pair_$i'));
    }

    // Mezclamos cada columna
    _leftColumn.shuffle();
    _rightColumn.shuffle();
  }

  void _onCardTap(MatchCard card) async {
    if (_isProcessing || card.state == CardState.matched || card == _firstSelected) return;

    setState(() {
      card.state = CardState.selected;
    });

    if (_firstSelected == null) {
      _firstSelected = card;
    } else {
      _isProcessing = true;

      if (_firstSelected!.pairId == card.pairId) {
        // Acierto (Verde)
        setState(() {
          _firstSelected!.state = CardState.matched;
          card.state = CardState.matched;
          _firstSelected = null;
          _pairsFound++;
          _isProcessing = false;
        });

        if (_pairsFound == _totalPairs) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) Navigator.pop(context);
          });
        }
      } else {
        // Error (Rojo)
        setState(() {
          _firstSelected!.state = CardState.error;
          card.state = CardState.error;
        });

        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          setState(() {
            _firstSelected!.state = CardState.normal;
            card.state = CardState.normal;
            _firstSelected = null;
            _isProcessing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalPairs == 0 ? 0 : _pairsFound / _totalPairs;

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
                'PAREJAS: ${widget.deckTitle.toUpperCase()}',
                style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$_pairsFound / $_totalPairs',
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
        child: Row(
          children: [
            // Columna izquierda (Preguntas)
            Expanded(
              child: Column(
                children: _leftColumn.map((card) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildCard(card),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(width: 16),
            // Columna derecha (Respuestas)
            Expanded(
              child: Column(
                children: _rightColumn.map((card) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildCard(card),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(MatchCard card) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Color textColor = Colors.black87;

    switch (card.state) {
      case CardState.normal:
        bgColor = Colors.white;
        borderColor = Colors.grey.shade300;
        textColor = const Color(0xFF1D4ED8).withValues(alpha: 0.9);
        break;
      case CardState.selected:
        bgColor = const Color(0xFF1D4ED8);
        borderColor = const Color(0xFF1D4ED8);
        textColor = Colors.white;
        break;
      case CardState.matched: 
        bgColor = Colors.green.shade50;
        borderColor = Colors.green;
        textColor = Colors.green.shade800;
        break;
      case CardState.error: 
        bgColor = Colors.red.shade50;
        borderColor = Colors.red;
        textColor = Colors.red.shade800;
        break;
    }

    return GestureDetector(
      onTap: () => _onCardTap(card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: card.state == CardState.normal
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          card.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}