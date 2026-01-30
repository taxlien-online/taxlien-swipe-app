import '../core/models/property_card_data.dart';
import '../core/models/marker.dart';
import 'package:flutter/material.dart'; // Import for Offset

class TaxLienService {
  Future<List<PropertyCardData>> getPropertyCards() async {
    // Имитация задержки сети
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      // Property 1: Focus on Builder/Caregiver/Lifestyle
      PropertyCardData(
        id: '1',
        address: '123 Oak Street',
        city: 'Phoenix',
        state: 'AZ',
        estimatedValue: 180000,
        lienCost: 750,
        totalCost: 2500,
        roi: 15.0, // 15x multiplier potential (for foreclosure)
        fvi: 8.5,
        karmaScore: 0.7, // Good karma (blighted)
        imageUrls: [
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&h=600&fit=crop', // Exterior
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800&h=600&fit=crop', // Roof
          'https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?w=800&h=600&fit=crop', // Kitchen (needs update)
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&h=600&fit=crop', // Living Room
        ],
        imageCategories: {
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&h=600&fit=crop': 'exterior',
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800&h=600&fit=crop': 'roof',
          'https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?w=800&h=600&fit=crop': 'kitchen',
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&h=600&fit=crop': 'living_room',
        },
        expertReassurance: '🏗️ Khun Pho: "Foundation is solid. Roof needs minor patch."',
        roleMetrics: {
          'businessman': {'risk': 'Low (Blighted, High Profit)', 'yield': 'Potential 1200% on flip'},
          'builder': {'structure': 'A-', 'roof_age': '12 years (needs minor repair)', 'foundation': 'Excellent'},
          'caregiver': {'safety_score': '7/10', 'school_rating': '8/10 (Elementary)', 'hospital_dist_miles': '3.2'},
          'lifestyle': {'walk_score': '65 (Car Dependent)', 'cafes_nearby': '2', 'vibe': 'Quiet Suburban'},
          'explorer': {'backyard_size_sqft': '5000', 'park_dist_miles': '0.8', 'treehouse_potential': 'High'},
          'inventor': {'rarity_score': '1/10', 'authenticity': 'N/A'},
          'restorer': {'furniture_potential': 'Low', 'era': 'Modern'},
        },
        markers: [
          AnnotationMarker(
            id: 'm1',
            position: const Offset(100, 200),
            authorId: 'khun-pho',
            category: 'structure',
            comment: 'No visible cracks here',
            type: MarkerType.point,
            createdAt: DateTime.now(),
          ),
          AnnotationMarker(
            id: 'm2',
            position: const Offset(50, 50),
            authorId: 'khun-pho',
            category: 'roof',
            comment: 'Minor shingle damage',
            type: MarkerType.point,
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),

      // Property 2: Focus on Restorer/Lifestyle
      PropertyCardData(
        id: '2',
        address: '742 Evergreen Terrace',
        city: 'Springfield',
        state: 'IL',
        estimatedValue: 220000,
        lienCost: 1200,
        totalCost: 2500,
        roi: 0.18, // 18% interest if redeemed
        fvi: 9.2,
        karmaScore: 0.8,
        imageUrls: [
          'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&h=600&fit=crop', // Exterior
          'https://images.unsplash.com/photo-1519710164239-da187a6cd545?w=800&h=600&fit=crop', // Interior with vintage furniture
          'https://images.unsplash.com/photo-1599696200230-077553b6f0e4?w=800&h=600&fit=crop', // Another interior shot
        ],
        imageCategories: {
          'https://images.unsplash.com/photo-1519710164239-da187a6cd545?w=800&h=600&fit=crop': 'interior_furniture',
        },
        expertReassurance: '🛋️ Denis: "Vintage mahogany dining set inside!"',
        roleMetrics: {
          'businessman': {'risk': 'Low (High Redemption)', 'yield': '18% interest'},
          'builder': {'structure': 'B', 'roof_age': '5 years', 'foundation': 'Good'},
          'restorer': {'furniture_potential': 'High (Mahogany set)', 'era': 'Mid-century', 'restoration_cost_est': '\$500'},
          'lifestyle': {'walk_score': '92 (Walker\'s Paradise)', 'cafes_nearby': '5+', 'vibe': 'Lively Urban'},
          'caregiver': {'safety_score': '6/10', 'school_rating': '6/10'},
        },
      ),

      // Property 3: Focus on Inventor/Explorer (land)
      PropertyCardData(
        id: '3',
        address: 'Desert Plot 42',
        city: 'Mojave',
        state: 'CA',
        estimatedValue: 15000,
        lienCost: 300,
        totalCost: 450,
        roi: 10.0, // 10x land value potential
        fvi: 7.0,
        karmaScore: 0.4,
        imageUrls: [
          'https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800&h=600&fit=crop', // Satellite style
          'https://images.unsplash.com/photo-1536431316694-82f913d8ca80?w=800&h=600&fit=crop', // Another desert view
        ],
        imageCategories: {
          'https://images.unsplash.com/photo-1473580044384-7ba913d8ca80?w=800&h=600&fit=crop': 'satellite',
        },
        expertReassurance: '🔬 Anton: "Near a historical research site. Rare minerals suspected."',
        roleMetrics: {
          'businessman': {'risk': 'High (Speculative Land)', 'yield': 'Variable'},
          'inventor': {'rarity_score': '9/10 (Historical)', 'authenticity': 'Unconfirmed', 'x1000_potential': 'High'},
          'explorer': {'adventure_score': '10/10', 'secret_spots': 'Many', 'bike_score': '1/10 (No roads)'},
        },
        markers: [
          AnnotationMarker(
            id: 'm3',
            position: const Offset(300, 400),
            authorId: 'anton',
            category: 'research',
            comment: 'Possible Rife machine components buried here.',
            type: MarkerType.point,
            createdAt: DateTime.now(),
          ),
        ],
      ),
      // Property 4: Focus on Builder/Inventor (house, but land potential)
      PropertyCardData(
        id: '4',
        address: '456 Juniper Lane',
        city: 'Tucson',
        state: 'AZ',
        estimatedValue: 90000,
        lienCost: 400,
        totalCost: 650,
        roi: 8.0, 
        fvi: 7.5,
        karmaScore: 0.6,
        imageUrls: [
          'https://images.unsplash.com/photo-1582268481498-8c17377855b9?w=800&h=600&fit=crop', // Exterior (older house)
          'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800&h=600&fit=crop', // Old garage
          'https://images.unsplash.com/photo-1520302685710-bb65636384f6?w=800&h=600&fit=crop', // Interior (old)
        ],
        imageCategories: {
          'https://images.unsplash.com/photo-1582268481498-8c17377855b9?w=800&h=600&fit=crop': 'exterior',
          'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800&h=600&fit=crop': 'garage',
        },
        expertReassurance: '🔬 Anton: "Check the garage! Old tech could be there."',
        roleMetrics: {
          'builder': {'structure': 'C+', 'roof_age': '20 years (needs replacement)', 'foundation': 'Fair'},
          'inventor': {'rarity_score': '7/10', 'authenticity': 'Needs Verification', 'x1000_potential': 'Medium'},
          'businessman': {'risk': 'Medium (Fixer-upper)', 'yield': '200% on flip'},
        },
        markers: [
          AnnotationMarker(
            id: 'm4',
            position: const Offset(500, 300),
            authorId: 'anton',
            category: 'technology',
            comment: 'Looks like a custom-built antenna in the garage.',
            type: MarkerType.point,
            createdAt: DateTime.now(),
          ),
        ],
      ),
    ];
  }
}