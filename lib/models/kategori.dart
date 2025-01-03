class Kategori {
  final String uid;
  final String nama;

  Kategori({
    required this.uid,
    required this.nama,
  });

  // Konversi dari JSON ke objek Kategori
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      uid: json['uid'],
      nama: json['kategori'],
    );
  }

  // Konversi dari objek Kategori ke JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'kategori': nama,
    };
  }
}