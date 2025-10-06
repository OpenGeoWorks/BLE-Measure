import 'dart:math';

class DistanceCalculator {
  static double calculate(double rssi, {int txPower = -59, double n = 2.0}) {
    return double.parse(
        (pow(10, (txPower - rssi) / (10 * n))).toStringAsFixed(2));
  }
}
