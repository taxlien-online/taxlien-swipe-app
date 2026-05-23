import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../services/tax_lien_service.dart';
import '../../analytics/facebook_app_events_service.dart';
import '../../profile/services/expert_profile_service.dart';
import '../models/annotation.dart';

class AnnotationScreen extends StatefulWidget {
  final String propertyId;

  const AnnotationScreen({
    super.key,
    required this.propertyId,
  });

  @override
  State<AnnotationScreen> createState() => _AnnotationScreenState();
}

class _AnnotationScreenState extends State<AnnotationScreen> {
  late Future<TaxLien?> _propertyFuture;
  final List<Annotation> _annotations = [];
  final Set<String> _loggedAnnotationIds = {};
  AnnotationType _currentType = AnnotationType.point;
  List<Offset> _currentDrawingPoints = [];
  bool _isDrawing = false;

  @override
  void initState() {
    super.initState();
    _propertyFuture = TaxLienService().getTaxLienById(widget.propertyId);
  }

  void _onPanStart(DragStartDetails details, BoxConstraints constraints) {
    setState(() {
      _isDrawing = true;
      final normalizedPoint = Offset(
        details.localPosition.dx / constraints.maxWidth,
        details.localPosition.dy / constraints.maxHeight,
      );
      _currentDrawingPoints = [normalizedPoint];
    });
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_currentType == AnnotationType.point) return;
    
    setState(() {
      final normalizedPoint = Offset(
        details.localPosition.dx / constraints.maxWidth,
        details.localPosition.dy / constraints.maxHeight,
      );
      _currentDrawingPoints.add(normalizedPoint);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentDrawingPoints.isEmpty) return;

    final profile = Provider.of<ExpertProfileService>(context, listen: false).currentProfile;

    final newAnnotation = Annotation(
      id: const Uuid().v4(),
      propertyId: widget.propertyId,
      expertId: profile.id,
      type: _currentType,
      points: List.from(_currentDrawingPoints),
    );

    setState(() {
      _annotations.add(newAnnotation);
      _currentDrawingPoints = [];
      _isDrawing = false;
    });

    _showCommentDialog(newAnnotation);
  }

  void _showCommentDialog(Annotation annotation) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expert Observation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Describe what you see...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice recording started... (Gateway API required)'))
                );
              },
              icon: const Icon(Icons.mic),
              label: const Text('Add Voice Note'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (!_loggedAnnotationIds.contains(annotation.id)) {
                _loggedAnnotationIds.add(annotation.id);
                final profile = Provider.of<ExpertProfileService>(context, listen: false).currentProfile;
                Provider.of<FacebookAppEventsService>(context, listen: false)
                    .logAnnotationAdded(annotation.propertyId, profile.id);
              }
              Navigator.pop(context);
            },
            child: const Text('Save Mark'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ExpertProfileService>(context).currentProfile;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Annotating: ${profile.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final profile = Provider.of<ExpertProfileService>(context, listen: false).currentProfile;
              final fbEvents = Provider.of<FacebookAppEventsService>(context, listen: false);
              for (final a in _annotations) {
                if (!_loggedAnnotationIds.contains(a.id)) {
                  _loggedAnnotationIds.add(a.id);
                  fbEvents.logAnnotationAdded(a.propertyId, profile.id);
                }
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<TaxLien?>(
        future: _propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final property = snapshot.data;
          if (property == null) return const Center(child: Text('Property not found', style: TextStyle(color: Colors.white)));

          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onPanStart: (d) => _onPanStart(d, constraints),
                      onPanUpdate: (d) => _onPanUpdate(d, constraints),
                      onPanEnd: _onPanEnd,
                      child: Stack(
                        children: [
                          // Base image
                          Positioned.fill(
                            child: Image.network(
                              property.images.first,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Existing annotations
                          ..._annotations.map((a) => _buildAnnotationWidget(a, constraints)),
                          // Current drawing
                          if (_isDrawing)
                            _buildAnnotationWidget(
                              Annotation(
                                id: 'temp',
                                propertyId: '',
                                expertId: '',
                                type: _currentType,
                                points: _currentDrawingPoints,
                              ),
                              constraints,
                              isTemp: true,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildToolbar(),
              _buildInstructions(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnnotationWidget(Annotation a, BoxConstraints constraints, {bool isTemp = false}) {
    final profileService = Provider.of<ExpertProfileService>(context, listen: false);
    final color = isTemp ? Colors.white : profileService.getProfileColor(a.expertId);

    return CustomPaint(
      size: Size(constraints.maxWidth, constraints.maxHeight),
      painter: AnnotationPainter(
        annotation: a,
        color: color,
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolButton(AnnotationType.point, Icons.location_on, 'Point'),
          _buildToolButton(AnnotationType.line, Icons.gesture, 'Line'),
          _buildToolButton(AnnotationType.area, Icons.aspect_ratio, 'Area'),
          _buildToolButton(AnnotationType.text, Icons.text_fields, 'Text'),
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.white),
            onPressed: _annotations.isEmpty ? null : () {
              setState(() => _annotations.removeLast());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(AnnotationType type, IconData icon, String label) {
    final isSelected = _currentType == type;
    return GestureDetector(
      onTap: () => setState(() => _currentType = type),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.white70),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black,
      width: double.infinity,
      child: const Text(
        'Draw directly on the property photo. Your annotations are stored in the Gateway.',
        textAlign: TextAlign.center,
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11, color: Colors.white54),
      ),
    );
  }
}

class AnnotationPainter extends CustomPainter {
  final Annotation annotation;
  final Color color;

  AnnotationPainter({
    required this.annotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = annotation.points.map((p) => Offset(
      p.dx * size.width,
      p.dy * size.height,
    )).toList();

    if (points.isEmpty) return;

    switch (annotation.type) {
      case AnnotationType.point:
        canvas.drawCircle(points.first, 8, paint..style = PaintingStyle.fill);
        canvas.drawCircle(points.first, 12, paint..style = PaintingStyle.stroke..color = Colors.white);
        break;
      case AnnotationType.line:
        for (int i = 0; i < points.length - 1; i++) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
        break;
      case AnnotationType.area:
        if (points.length > 2) {
          final path = Path()..moveTo(points.first.dx, points.first.dy);
          for (var p in points.skip(1)) {
            path.lineTo(p.dx, p.dy);
          }
          path.close();
          canvas.drawPath(path, paint..style = PaintingStyle.fill..color = color.withOpacity(0.3));
          canvas.drawPath(path, paint..style = PaintingStyle.stroke..color = color);
        }
        break;
      case AnnotationType.text:
        // Text drawing logic placeholder
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
