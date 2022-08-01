class JenisModel {
  int? idJenis;
  String? jenisBarang;

  JenisModel({this.idJenis, this.jenisBarang});

  JenisModel.fromJson(Map<String, dynamic> json) {
    idJenis = json['id_jenis'];
    jenisBarang = json['jenis_barang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_jenis'] = this.idJenis;
    data['jenis_barang'] = this.jenisBarang;
    return data;
  }
}
