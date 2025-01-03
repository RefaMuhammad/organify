import 'package:flutter/material.dart';
import 'package:organify/controllers/catatan.dart';
import 'package:organify/screens/edittask_page.dart';
import 'button.dart';

class TaskItem extends StatefulWidget {
  final String taskName;
  final String deadline;
  final String idCatatan; // ID catatan
  final String uid;

  const TaskItem({
    Key? key,
    required this.taskName,
    required this.deadline,
    required this.idCatatan,
    required this.uid,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _isCompleted = false; // State untuk menandai apakah tugas sudah selesai

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTaskPage(
              taskName: widget.taskName,
              deadline: widget.deadline,
              uid: widget.uid,
              idCatatan: widget.idCatatan,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    // Panggil method untuk mengupdate status tugas
                    final catatanController = CatatanController();
                    try {
                      await catatanController.updateStatusCatatan(
                        widget.uid,
                        widget.idCatatan,
                        true, // Set status menjadi true (selesai)
                      );
                      setState(() {
                        _isCompleted = true; // Update state lokal
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tugas berhasil diselesaikan!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengupdate status tugas: $e')),
                      );
                    }
                  },
                  child: Icon(
                    _isCompleted ? Icons.check_circle : Icons.circle_outlined,
                    size: 24,
                    color: _isCompleted ? Colors.green : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
                          'assets/catatan.png',
                          width: 16, // Atur ukuran sesuai kebutuhan
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.deadline,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}