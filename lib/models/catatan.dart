class Catatan {
  final String id;
  final String kategori;
  final String namaList;
  final bool status;
  final DateTime tanggalDeadline;

  Catatan({
    required this.id,
    required this.kategori,
    required this.namaList,
    required this.status,
    required this.tanggalDeadline,
  });

  factory Catatan.fromJson(Map<String, dynamic> json) {
    return Catatan(
      id: json['id'],
      kategori: json['kategori'],
      namaList: json['namaList'],
      status: json['status'],
      tanggalDeadline: DateTime.parse(json['tanggalDeadline']),
    );
  }
}