import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GrafikBatang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Tinggi grafik
      padding: const EdgeInsets.all(10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 4, // Menggunakan toY sebagai ganti y
                  color: Color(0xFF89A8B2), // Menggunakan color sebagai ganti colors
                  width: 15,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 10,
                  color: Color(0xFF89A8B2),
                  width: 15,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 7,
                  color: Color(0xFF89A8B2),
                  width: 15,
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: 12,
                  color: Color(0xFF89A8B2),
                  width: 15,
                ),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: 9,
                  color: Color(0xFF89A8B2),
                  width: 15,
                ),
              ],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(
                  toY: 11,
                  color: Color(0xFF89A8B2),
                  width: 15,
                ),
              ],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(
                  toY: 6,
                  color: Color(0xFF89A8B2),
                  width: 15,
                ),
              ],
            ),
          ],
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: false, // Sembunyikan judul sumbu
          ),
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
  }
}