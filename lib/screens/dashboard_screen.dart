import 'package:flutter/material.dart';
import 'srs_mode_screen.dart';
import 'match_mode_screen.dart';
import 'written_mode_screen.dart';

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
      'newCards': 15,
    },
    {
      'title': 'Constitución Española',
      'progress': 0.15,
      'color': Colors.orange.shade500,
      'newCards': 7,
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

  Widget _buildDeckCard(Map<String, dynamic> deck) {
    return GestureDetector(
      onTap: () => _showStudyModeDialog(context, deck['title']),
      child: Container(
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
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
            Text(
              '${(deck['progress'] * 100).toInt()}% Dominado • ${deck['newCards']} tarjetas nuevas',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // Menú para elegir el modo de estudio
  void _showStudyModeDialog(BuildContext context, String deckTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Estudiar $deckTitle', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.style, color: Colors.blue.shade600),
                  ),
                  title: const Text('Repetición Espaciada', style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SrsModeScreen(deckTitle: deckTitle)),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.grid_view, color: Colors.blue.shade600),
                  ),
                  title: const Text('Parejas', style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _showConfigDialog(context, deckTitle, false);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.edit_note, color: Colors.blue.shade600),
                  ),
                  title: const Text('Respuesta Escrita', style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _showConfigDialog(context, deckTitle, true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Diálogo para la elección del número de tarjetas
  void _showConfigDialog(BuildContext context, String deckTitle, bool isWrittenMode) {
    // Si es modo escritura: min 1, max 16 (divisiones de 1 en 1 = 15 divisiones)
    // Si es modo parejas: min 2, max 32 (divisiones de 2 en 2 = 15 divisiones)
    
    double minVal = isWrittenMode ? 1 : 2;
    double maxVal = isWrittenMode ? 16 : 32;
    int divisions = 15;
    double sliderValue = 4;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Configurar sesión', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Elige el número de tarjetas a estudiar.', style: TextStyle(color: Colors.black87)),
                  const SizedBox(height: 24),
                  Text(
                    '${sliderValue.toInt()} Tarjetas',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8), fontSize: 18),
                  ),
                  Slider(
                    value: sliderValue,
                    min: minVal,
                    max: maxVal,
                    divisions: divisions,
                    activeColor: const Color(0xFF1D4ED8),
                    inactiveColor: Colors.blue.shade100,
                    onChanged: (value) => setState(() => sliderValue = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => isWrittenMode 
                          ? WrittenModeScreen(deckTitle: deckTitle)
                          : MatchModeScreen(deckTitle: deckTitle),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Empezar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }
}