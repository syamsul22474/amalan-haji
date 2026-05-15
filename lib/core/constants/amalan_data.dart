import '../models/amalan.dart';

class AmalanData {
  static const List<Amalan> amalan8Dzulhijjah = [
    Amalan(id: 'wangi_sebelum', nama: 'Memakai Wewangian sebelum Ihram', deskripsi: 'Disunahkan memakai minyak wangi di badan', jenis: JenisAmalan.sunnah, hariDzulhijjah: 8, urutan: 1),
    Amalan(id: 'ihram', nama: 'Ihram dari Miqat / Tempat Tinggal', deskripsi: 'Niat ihram disertai mandi & memakai wewangian', jenis: JenisAmalan.rukun, hariDzulhijjah: 8, urutan: 2),
    Amalan(id: 'talbiyah', nama: 'Mengucapkan Talbiyah', deskripsi: 'Mulai ihram hingga lontar Jumrah Aqabah', jenis: JenisAmalan.sunnah, hariDzulhijjah: 8, hariDzulhijjahEnd: 10, endConditionAmalanId: 'aqabah_10', urutan: 3),
    Amalan(id: 'berangkat_mina', nama: 'Berangkat ke Mina', deskripsi: 'Mabit di Mina malam 8 Dzulhijjah', jenis: JenisAmalan.sunnah, hariDzulhijjah: 8, urutan: 4),
    Amalan(id: 'sholat_mina_8', nama: 'Sholat 5 Waktu di Mina (Qashar)', deskripsi: 'Dzuhur, Ashar, Maghrib, Isya, Subuh — qashar tanpa jamak', jenis: JenisAmalan.sunnah, hariDzulhijjah: 8, urutan: 5),
  ];

  static const List<Amalan> amalan9Dzulhijjah = [
    Amalan(id: 'berangkat_arafah', nama: 'Bertolak ke Arafah setelah Subuh', deskripsi: 'Berangkat setelah matahari terbit', jenis: JenisAmalan.sunnah, hariDzulhijjah: 9, urutan: 1, waktuTrigger: 'syuruq'),
    Amalan(id: 'jamak_arafah', nama: 'Sholat Dzuhur & Ashar Jamak Qashar', deskripsi: 'Dijamak taqdim, diqashar di Arafah', jenis: JenisAmalan.sunnah, hariDzulhijjah: 9, urutan: 2, waktuTrigger: 'dhuhr'),
    Amalan(
      id: 'wukuf_arafah',
      nama: 'Wukuf di Arafah',
      deskripsi: 'Rukun : Hadir di Arafah\nWajib : Hadir di Arafah dari tergelincir matahari hingga terbenam',
      jenis: JenisAmalan.rukun,
      hariDzulhijjah: 9,
      urutan: 3,
      waktuTrigger: 'dhuhr',
      waktuKeterangan: 'Mulai : Dzuhur/Tergelincir matahari tanggal 9 Dzulhijjah\nBerakhir : hingga terbit fajar tanggal 10 Dzulhijjah',
    ),
    Amalan(id: 'doa_arafah', nama: 'Perbanyak Dzikir & Doa di Arafah', deskripsi: 'Menghadap kiblat, angkat tangan', jenis: JenisAmalan.sunnah, hariDzulhijjah: 9, urutan: 4),
    Amalan(id: 'berangkat_muzdalifah', nama: 'Bertolak ke Muzdalifah setelah Maghrib', deskripsi: 'Berangkat setelah matahari terbenam dengan tenang', jenis: JenisAmalan.sunnah, hariDzulhijjah: 9, urutan: 5, waktuTrigger: 'maghrib'),
    Amalan(id: 'mabit_muzdalifah', nama: 'Mabit di Muzdalifah', deskripsi: 'Menginap hingga terbit fajar', jenis: JenisAmalan.wajib, hariDzulhijjah: 9, urutan: 6),
    Amalan(id: 'jamak_muzdalifah', nama: 'Sholat Maghrib & Isya Jamak Takhir Qashar', deskripsi: 'Di Muzdalifah, satu azan dua iqamat', jenis: JenisAmalan.sunnah, hariDzulhijjah: 9, urutan: 7, waktuTrigger: 'isha'),
  ];

  static const List<Amalan> amalan10Dzulhijjah = [
    Amalan(id: 'subuh_muzdalifah', nama: 'Sholat Subuh di Awal Waktu', deskripsi: 'Di Muzdalifah, lebih awal dari biasanya', jenis: JenisAmalan.sunnah, hariDzulhijjah: 10, urutan: 1, waktuTrigger: 'fajr'),
    Amalan(id: 'doa_muzdalifah_pagi', nama: 'Berdoa Kepada Allah hingga menjelang terbit matahari', deskripsi: 'Sebelum matahari terbit', jenis: JenisAmalan.sunnah, hariDzulhijjah: 10, urutan: 2),
    Amalan(id: 'berangkat_mina_10', nama: 'Bertolak ke Mina sebelum Matahari Terbit', deskripsi: 'Berangkat sebelum matahari terbit', jenis: JenisAmalan.sunnah, hariDzulhijjah: 10, urutan: 3),
    Amalan(
      id: 'aqabah_10',
      nama: 'Lontar Jumrah Aqabah',
      deskripsi: '7 batu, waktu Dhuha, bertakbir setiap lemparan',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 10,
      urutan: 4,
      waktuKeterangan: 'Waktu Mulai : Tengah malam tanggal 10 Dzulhijjah\nWaktu Berakhir : Sebelum adzan shubuh tanggal 11 Dzulhijjah',
    ),
    Amalan(
      id: 'hadyu_10',
      nama: 'Menyembelih Hewan Kurban (Hadyu)',
      deskripsi: 'Diwajibkan bagi yang berhaji Tamattu dan Qiron',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 10,
      urutan: 5,
      waktuKeterangan: 'Waktu Mulai : 10 Dzulhijjah\nWaktu Berakhir : Sebelum terbenam matahari tanggal 13 Dzulhijjah',
    ),
    Amalan(id: 'cukur_10', nama: 'Bercukur/Potong Rambut', deskripsi: 'Cukur atau potong rambut merata (mencukur rambut dari segala sisi kepala)', jenis: JenisAmalan.wajib, hariDzulhijjah: 10, urutan: 6),
    Amalan(
      id: 'thawaf_ifadhah',
      nama: 'Thawaf Ifadhah',
      deskripsi: '7 putaran Ka\'bah, tidak disunahkan roml di 3 putaran pertama di thawaf ifadhah. Disunnahkan dikerjakan siang hari Tanggal 10 Dzulhijjah',
      jenis: JenisAmalan.rukun,
      hariDzulhijjah: 10,
      urutan: 7,
      waktuKeterangan: 'Waktu Mulai : Lewat tengah malam Tanggal 10 Dzulhijjah\nWaktu Berakhir : Tidak ada batas waktu',
    ),
    Amalan(id: 'sai', nama: 'Sa\'i Shafa-Marwah', deskripsi: '7 kali, berlari kecil di lembah al-Masil', jenis: JenisAmalan.rukun, hariDzulhijjah: 10, urutan: 8),
    Amalan(id: 'tahallul_awal', nama: 'Tahallul Awal', deskripsi: 'Dihalalkan segala sesuatu kecuali hal yang berkaitan dengan wanita yaitu berjimak, mubasyarah (bercumbu), dan akad nikah.', jenis: JenisAmalan.wajib, hariDzulhijjah: 10, urutan: 9),
    Amalan(id: 'tahallul_tsani', nama: 'Tahallul Tsani', deskripsi: 'Telah halal segala yang sebelumnya diharamkan saat ihram', jenis: JenisAmalan.wajib, hariDzulhijjah: 10, urutan: 10),
    Amalan(id: 'mabit_mina_10', nama: 'Mabit di Mina malam 11 Dzulhijjah', deskripsi: 'Kembali ke Mina setelah Thawaf Ifadhah', jenis: JenisAmalan.wajib, hariDzulhijjah: 10, urutan: 11),
  ];

  static const List<Amalan> amalan11Dzulhijjah = [
    Amalan(id: 'ula_11', nama: 'Lontar Jumrah Ula (Sughra)', deskripsi: '7 batu setelah Dzuhur, berdoa setelahnya', jenis: JenisAmalan.wajib, hariDzulhijjah: 11, urutan: 1, waktuTrigger: 'dhuhr'),
    Amalan(id: 'wustha_11', nama: 'Lontar Jumrah Wustha', deskripsi: '7 batu setelah Ula, berdoa setelahnya', jenis: JenisAmalan.wajib, hariDzulhijjah: 11, urutan: 2),
    Amalan(id: 'aqabah_11', nama: 'Lontar Jumrah Aqabah (Kubra)', deskripsi: '7 batu, tidak berdoa setelahnya', jenis: JenisAmalan.wajib, hariDzulhijjah: 11, urutan: 3),
    Amalan(id: 'mabit_mina_11', nama: 'Mabit di Mina malam 12 Dzulhijjah', deskripsi: 'Menginap di Mina', jenis: JenisAmalan.wajib, hariDzulhijjah: 11, urutan: 4),
  ];

  static const List<Amalan> amalan12Dzulhijjah = [
    Amalan(id: 'tiga_jumrah_12', nama: 'Lontar 3 Jumrah (Ula, Wustha, Aqabah)', deskripsi: 'Sama seperti hari ke-4, setelah Dzuhur', jenis: JenisAmalan.wajib, hariDzulhijjah: 12, urutan: 1, waktuTrigger: 'dhuhr'),
    Amalan(id: 'nafar_awal_12', nama: 'Nafar Awal (Opsional)', deskripsi: 'Boleh meninggalkan Mina sebelum Maghrib', jenis: JenisAmalan.wajib, hariDzulhijjah: 12, urutan: 2),
    Amalan(id: 'mabit_mina_12', nama: 'Mabit di Mina malam 13 Dzulhijjah', deskripsi: 'Bagi yang tidak mengambil Nafar Awal', jenis: JenisAmalan.wajib, hariDzulhijjah: 12, urutan: 3),
  ];

  static const List<Amalan> amalan13Dzulhijjah = [
    Amalan(id: 'tiga_jumrah_13', nama: 'Lontar 3 Jumrah (Ula, Wustha, Aqabah)', deskripsi: 'Bagi yang Nafar Tsani, setelah Dzuhur', jenis: JenisAmalan.wajib, hariDzulhijjah: 13, urutan: 1, waktuTrigger: 'dhuhr'),
    Amalan(id: 'tinggal_mina_13', nama: 'Meninggalkan Mina', deskripsi: 'Setelah selesai lontar', jenis: JenisAmalan.wajib, hariDzulhijjah: 13, urutan: 2),
    Amalan(id: 'thawaf_wada_13', nama: 'Thawaf Wada\'', deskripsi: 'Amalan terakhir sebelum pulang, tidak wajib bagi wanita haid', jenis: JenisAmalan.wajib, hariDzulhijjah: 13, urutan: 3),
  ];

  static const List<Amalan> allAmalan = [
    ...amalan8Dzulhijjah,
    ...amalan9Dzulhijjah,
    ...amalan10Dzulhijjah,
    ...amalan11Dzulhijjah,
    ...amalan12Dzulhijjah,
    ...amalan13Dzulhijjah,
  ];
}
