import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:organify/controllers/catatan.dart'; // Import CatatanController

class GrafikBatang extends StatefulWidget {
  final String uid;
  final String tanggalAwal;

  GrafikBatang({required this.uid, required this.tanggalAwal});

  @override
  _GrafikBatangState createState() => _GrafikBatangState();
}

class _GrafikBatangState extends State<GrafikBatang> {
  List<int> tugasPerHari = [];
  final CatatanController _catatanController = CatatanController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(GrafikBatang oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tanggalAwal != widget.tanggalAwal) {
      fetchData(); // Ambil data baru jika tanggalAwal berubah
    }
  }

  Future<void> fetchData() async {
    try {
      DateTime startDate = DateTime.parse(widget.tanggalAwal);
      List<int> jumlahTugasPerHari = [];

      // Hitung jumlah tugas selesai untuk setiap hari dalam seminggu
      for (int i = 0; i < 7; i++) {
        DateTime tanggal = startDate.add(Duration(days: i));
        int jumlahTugas = await _catatanController.getJumlahTugasSelesaiPadaHari(widget.uid, tanggal);
        jumlahTugasPerHari.add(jumlahTugas);
      }

      setState(() {
        tugasPerHari = jumlahTugasPerHari;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Tinggi grafik
      padding: const EdgeInsets.all(10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: tugasPerHari.asMap().entries.map((entry) {
            int x = entry.key;
            int toY = entry.value;
            return BarChartGroupData(
              x: x,
              barRods: [
                BarChartRodData(
                  toY: toY.toDouble(),
                  color: Color(0xFF89A8B2),
                  width: 15,
                ),
              ],
            );
          }).toList(),
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