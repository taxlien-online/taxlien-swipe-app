import 'package:flutter/material.dart';

class FVI {
  final double financialScore; // 0.0 - 10.0 (ROI, Tax history)
  final Map<String, double> expertScores; // { "khun_pho": 8.0, "denis": 9.5 }
  final double propertyCost;

  const FVI({
    required this.financialScore,
    required this.expertScores,
    required this.propertyCost,
  });

  /// Главная метрика: Индекс Полной Пользы
  double get totalIndex {
    if (propertyCost <= 0) return 0.0;
    
    double totalPersonalValue = expertScores.values.fold(0, (prev, element) => prev + element);
    
    // (Финансовая ценность + Личная ценность всех экспертов) / Стоимость
    // Коэффициент нормализации для удобного отображения (например, звезды 0-10)
    return (financialScore + totalPersonalValue) / (propertyCost / 1000); 
  }

  /// Получить оценку конкретного эксперта
  double getScoreFor(String expertId) => expertScores[expertId] ?? 0.0;

  /// Есть ли у объекта потенциал "Jackpot" (x1000)
  bool get isJackpot => expertScores.values.any((score) => score >= 9.5);
}
