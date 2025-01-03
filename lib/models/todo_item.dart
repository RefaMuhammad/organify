class TodoItem {
  final String judul;
  final String isi;
  final DateTime terakhirDiperbarui;

  TodoItem({
    required this.judul,
    required this.isi,
    required this.terakhirDiperbarui,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      judul: json['judul'],
      isi: json['isi'],
      terakhirDiperbarui: DateTime.parse(json['terakhirDiperbarui']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'isi': isi,
      'terakhirDiperbarui': terakhirDiperbarui.toIso8601String(),
    };
  }
}