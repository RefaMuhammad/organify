class Catatan {
  final String id;
  final String dibuatPada;
  final String kategori;
  final String namaList;
  final bool status;
  final String tanggalDeadline;

  Catatan({
    required this.id,
    required this.dibuatPada,
    required this.kategori,
    required this.namaList,
    required this.status,
    required this.tanggalDeadline,
  });

  factory Catatan.fromJson(Map<String, dynamic> json) {
    return Catatan(
      id: json['id'],
      dibuatPada: json['dibuatPada'],
      kategori: json['kategori'],
      namaList: json['namaList'],
      status: json['status'],
      tanggalDeadline: json['tanggalDeadline'],
    );
  }
}