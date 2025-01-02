import 'package:flutter/material.dart';
import 'package:organify/screens/edittask_page.dart';
import 'button.dart';

class TaskItem extends StatelessWidget {
  final String id; // Tambahkan parameter id
  final String taskName;
  final String deadline;

  const TaskItem({
    Key? key,
    required this.id, // Wajib diisi
    required this.taskName,
    required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTaskPage(
              id: id, // Sertakan id saat navigasi
              taskName: taskName,
              deadline: deadline,
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
                const Icon(Icons.circle_outlined, size: 24),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskName,
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
                          deadline,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const MyButton(),
          ],
        ),
      ),
    );
  }
}