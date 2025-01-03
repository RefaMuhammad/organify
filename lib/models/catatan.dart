import 'package:organify/models/todo_item.dart';
class Catatan {
  final String id;
  final String dibuatPada;
  final String kategori;
  final String namaList;
  final bool status;
  final String tanggalDeadline;
  final TodoItem? todoItem;

  Catatan({
    required this.id,
    required this.dibuatPada,
    required this.kategori,
    required this.namaList,
    required this.status,
    required this.tanggalDeadline,
    this.todoItem,
  });

  factory Catatan.fromJson(Map<String, dynamic> json) {
    return Catatan(
      id: json['id'],
      dibuatPada: json['dibuatPada'],
      kategori: json['kategori'],
      namaList: json['namaList'],
      status: json['status'],
      tanggalDeadline: json['tanggalDeadline'],
      todoItem: json['todoItem'] != null
          ? TodoItem.fromJson(json['todoItem']) // Konversi JSON ke TodoItem
          : null,
    );
  }

  // Method untuk mengonversi Catatan ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dibuatPada': dibuatPada,
      'kategori': kategori,
      'namaList': namaList,
      'status': status,
      'tanggalDeadline': tanggalDeadline,
      'todoItem': todoItem?.toJson(), // Konversi TodoItem ke JSON
    };
  }
}