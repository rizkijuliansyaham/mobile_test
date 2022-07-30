class Transaksi {
  int? idTransaksi;
  String? namaBarang;
  int? jumlahTerjual;
  String? tanggalTransaksi;

  Transaksi(
      {this.idTransaksi,
      this.namaBarang,
      this.jumlahTerjual,
      this.tanggalTransaksi});

  Transaksi.fromJson(Map<String, dynamic> json) {
    idTransaksi = json['id_transaksi'];
    namaBarang = json['nama_barang'];
    jumlahTerjual = json['jumlah_terjual'];
    tanggalTransaksi = json['tanggal_transaksi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_transaksi'] = this.idTransaksi;
    data['nama_barang'] = this.namaBarang;
    data['jumlah_terjual'] = this.jumlahTerjual;
    data['tanggal_transaksi'] = this.tanggalTransaksi;
    return data;
  }
}
