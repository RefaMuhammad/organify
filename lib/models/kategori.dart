class Kategori {
  final String uid;
  final String kategori;

  Kategori({
    required this.uid,
    required this.kategori,
  });

  // Konversi dari JSON ke objek Kategori
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      uid: json['uid'],
      kategori: json['kategori'],
    );
  }

  // Konversi dari objek Kategori ke JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'kategori': kategori,
    };
  }
}