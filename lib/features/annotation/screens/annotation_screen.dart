import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../services/tax_lien_service.dart';
import '../../profile/services/expert_profile_service.dart';
import '../../profile/models/expert_profile.dart';
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
  final List<PropertyAnnotation> _annotations = [];
  AnnotationType _activeTool = AnnotationType.point;
  TaxLien? _property;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

  Future<void> _loadProperty() async {
    final property = TaxLienService.getMockLiens().firstWhere((p) => p.id == widget.propertyId);
    setState(() {
      _property = property;
      _isLoading = false;
    });
  }

  void _addAnnotation(Offset localPosition, Size containerSize) {
    final expertProfile = Provider.of<ExpertProfileService>(context, listen: false).currentProfile;
    
    final normalizedPosition = Offset(
      localPosition.dx / containerSize.width,
      localPosition.dy / containerSize.height,
    );

    final newAnnotation = PropertyAnnotation(
      id: const Uuid().v4(),
      expertId: expertProfile.id,
      position: normalizedPosition,
      type: _activeTool,
      createdAt: DateTime.now(),
    );

    setState(() {
      _annotations.add(newAnnotation);
    });

    _showCommentDialog(newAnnotation);
  }

  void _showCommentDialog(PropertyAnnotation annotation) {
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
                  const SnackBar(content: Text('Voice recording started...'))
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
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final expertProfile = Provider.of<ExpertProfileService>(context).currentProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expert: ${expertProfile.name}'),
        backgroundColor: expertProfile.color.withOpacity(0.1),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildToolBar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapUp: (details) => _addAnnotation(details.localPosition, Size(constraints.maxWidth, constraints.maxHeight)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          _property!.images.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ..._annotations.map((a) => _buildAnnotationWidget(a, constraints.maxWidth, constraints.maxHeight)),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildInstructions(),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toolButton(AnnotationType.point, Icons.ads_click, 'Point'),
          _toolButton(AnnotationType.line, Icons.linear_scale, 'Line'),
          _toolButton(AnnotationType.area, Icons.rectangle_outlined, 'Area'),
        ],
      ),
    );
  }

  Widget _toolButton(AnnotationType type, IconData icon, String label) {
    final isSelected = _activeTool == type;
    return GestureDetector(
      onTap: () => setState(() => _activeTool = type),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAnnotationWidget(PropertyAnnotation a, double width, double height) {
    final profile = ExpertProfile.allProfiles.firstWhere((p) => p.id == a.expertId);
    
    return Positioned(
      left: a.position.dx * width - 12,
      top: a.position.dy * height - 12,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: profile.color.withOpacity(0.8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
        ),
        child: Icon(_getIconForType(a.type), size: 14, color: Colors.white),
      ),
    );
  }

  IconData _getIconForType(AnnotationType type) {
    switch (type) {
      case AnnotationType.point: return Icons.location_on;
      case AnnotationType.line: return Icons.straighten;
      case AnnotationType.area: return Icons.crop_free;
    }
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      width: double.infinity,
      child: const Text(
        'Tap photo to add an expert mark. These marks train our AI to see value like you do.',
        textAlign: TextAlign.center,
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),
      ),
    );
  }
}