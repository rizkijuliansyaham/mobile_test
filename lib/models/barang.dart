class BarangModel {
  String? namaBarang;
  int? stok;
  int? idJenis;

  BarangModel({this.namaBarang, this.stok, this.idJenis});

  BarangModel.fromJson(Map<String, dynamic> json) {
    namaBarang = json['nama_barang'];
    stok = json['stok'];
    idJenis = json['id_jenis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama_barang'] = this.namaBarang;
    data['stok'] = this.stok;
    data['id_jenis'] = this.idJenis;
    return data;
  }
}
