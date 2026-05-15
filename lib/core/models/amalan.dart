enum JenisAmalan {
  rukun,
  wajib,
  sunnah,
  pilihan,
}

class Amalan {
  final String id;
  final String nama;
  final String deskripsi;
  final String dalil;
  final JenisAmalan jenis;
  final int hariDzulhijjah;
  final int? hariDzulhijjahEnd;
  final String? endConditionAmalanId;
  final String? dependsOnAmalanId;
  final String? waktuTrigger;
  final String? waktuKeterangan;
  final bool sudahDilakukan;
  final int urutan;

  const Amalan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    this.dalil = '',
    required this.jenis,
    required this.hariDzulhijjah,
    this.hariDzulhijjahEnd,
    this.endConditionAmalanId,
    this.dependsOnAmalanId,
    this.waktuTrigger,
    this.waktuKeterangan,
    this.sudahDilakukan = false,
    required this.urutan,
  });

  Amalan copyWith({
    bool? sudahDilakukan,
  }) =>
      Amalan(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        dalil: dalil,
        jenis: jenis,
        hariDzulhijjah: hariDzulhijjah,
        hariDzulhijjahEnd: hariDzulhijjahEnd,
        endConditionAmalanId: endConditionAmalanId,
        dependsOnAmalanId: dependsOnAmalanId,
        waktuTrigger: waktuTrigger,
        waktuKeterangan: waktuKeterangan,
        sudahDilakukan: sudahDilakukan ?? this.sudahDilakukan,
        urutan: urutan,
      );
}
