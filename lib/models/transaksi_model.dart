class TransaksiModel {
  int? idTransaksi;
  String? namaBarang;
  int? idJenis;
  int? jumlahTerjual;
  String? tanggalTransaksi;

  TransaksiModel(
      {this.idTransaksi,
      this.namaBarang,
      this.idJenis,
      this.jumlahTerjual,
      this.tanggalTransaksi});

  TransaksiModel.fromJson(Map<String, dynamic> json) {
    idTransaksi = json['id_transaksi'];
    namaBarang = json['nama_barang'];
    idJenis = json['id_jenis'];
    jumlahTerjual = json['jumlah_terjual'];
    tanggalTransaksi = json['tanggal_transaksi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_transaksi'] = this.idTransaksi;
    data['nama_barang'] = this.namaBarang;
    data['id_jenis'] = this.idJenis;
    data['jumlah_terjual'] = this.jumlahTerjual;
    data['tanggal_transaksi'] = this.tanggalTransaksi;
    return data;
  }
}
