class Kategori {
  final String kategori;
  final int jumlahCatatan;

  Kategori({
    required this.kategori,
    required this.jumlahCatatan,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      kategori: json['kategori'],
      jumlahCatatan: json['jumlahCatatan'],
    );
  }
}