class WaterCalculator {
  static const double runoffCoefficient = 0.8;
  static const List<int> standardTankSizes = [500, 1000, 2000, 5000, 10000];

  static double calculatePotential(double area, double rainfall) {
    // Method: Area (m²) * Rainfall (mm) * Coefficient = Liters
    return area * rainfall * runoffCoefficient;
  }

  static double calculateCycles(double potential, int tankSize) {
    if (tankSize == 0) return 0;
    return potential / tankSize;
  }

  static int recommendTankSize(double potential) {
    // 10% - 20% of annual potential
    double minRec = potential * 0.10;
    double maxRec = potential * 0.20;
    double target = (minRec + maxRec) / 2;

    // Find nearest standard size
    int nearest = standardTankSizes.first;
    double minDiff = (target - nearest).abs();

    for (int size in standardTankSizes) {
      double diff = (target - size).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = size;
      }
    }
    return nearest;
  }
}
