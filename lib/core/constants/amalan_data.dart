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
    Amalan(id: 'tahallul_awal', nama: 'Tahallul Awal', deskripsi: 'Dihalalkan segala sesuatu kecuali hal yang berkaitan dengan wanita yaitu berjimak, mubasyarah (bercumbu), dan akad nikah.', jenis: JenisAmalan.status, hariDzulhijjah: 10, urutan: 9),
    Amalan(id: 'tahallul_tsani', nama: 'Tahallul Tsani', deskripsi: 'Telah halal segala yang sebelumnya diharamkan saat ihram', jenis: JenisAmalan.status, hariDzulhijjah: 10, urutan: 10),
    Amalan(
      id: 'mabit_mina_10',
      nama: 'Mabit di Mina malam 11 Dzulhijjah',
      deskripsi: 'Kembali ke Mina setelah Thawaf Ifadhah.\n\nKetentuan:\nMenghabiskan sebagian besar malam di Mina, Jika dari terbenam matahari hingga terbit fajar 12 jam, maka wajib berada di Mina minimal 6 jam atau lebih sedikit',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 10,
      urutan: 11,
    ),
  ];

  static const List<Amalan> amalan11Dzulhijjah = [
    Amalan(
      id: 'ula_11',
      nama: 'Lontar Jumrah Ula (Sughra)',
      deskripsi: '7 batu setelah Dzuhur, berdoa setelahnya.\n\nSunnah Ketika melempar jumrah ula:\n1. Ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\n2. Setelah melempar jumroh ula disunnahkan untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 11,
      urutan: 1,
      waktuTrigger: 'dhuhr',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(
      id: 'wustha_11',
      nama: 'Lontar Jumrah Wustha',
      deskripsi: '7 batu setelah Ula, berdoa setelahnya.\n\nSunnah Ketika melempar jumrah wustho:\n1. Ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\n2. Setelah melempar jumroh wustho disunnahkan untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 11,
      urutan: 2,
      dependsOnAmalanId: 'ula_11',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(
      id: 'aqabah_11',
      nama: 'Lontar Jumrah Aqabah (Kubra)',
      deskripsi: '7 batu, tidak berdoa setelahnya.\n\nKetentuan :\nDisunnahkan ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\nTidak disunnahkan Setelah melempar jumroh aqabah untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 11,
      urutan: 3,
      dependsOnAmalanId: 'wustha_11',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(
      id: 'mabit_mina_11',
      nama: 'Mabit di Mina malam 12 Dzulhijjah',
      deskripsi: 'Menginap di Mina.\n\nKetentuan:\nMenghabiskan sebagian besar malam di Mina, Jika dari terbenam matahari hingga terbit fajar 12 jam, maka wajib berada di Mina minimal 6 jam atau lebih sedikit',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 11,
      urutan: 4,
    ),
  ];

  static const List<Amalan> amalan12Dzulhijjah = [
    Amalan(
      id: 'ula_12',
      nama: 'Lontar Jumrah Ula (Sughra)',
      deskripsi: '7 batu setelah Dzuhur, berdoa setelahnya.\n\nSunnah Ketika melempar jumrah ula:\n1. Ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\n2. Setelah melempar jumroh ula disunnahkan untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 12,
      urutan: 1,
      waktuTrigger: 'dhuhr',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(
      id: 'wustha_12',
      nama: 'Lontar Jumrah Wustha',
      deskripsi: '7 batu setelah Ula, berdoa setelahnya.\n\nSunnah Ketika melempar jumrah wustho:\n1. Ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\n2. Setelah melempar jumroh wustho disunnahkan untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 12,
      urutan: 2,
      dependsOnAmalanId: 'ula_12',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(
      id: 'aqabah_12',
      nama: 'Lontar Jumrah Aqabah (Kubra)',
      deskripsi: '7 batu, tidak berdoa setelahnya.\n\nKetentuan :\nDisunnahkan ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\nTidak disunnahkan Setelah melempar jumroh aqabah untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 12,
      urutan: 3,
      dependsOnAmalanId: 'wustha_12',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(id: 'nafar_awal_12', nama: 'Nafar Awal (Opsional)', deskripsi: 'Boleh meninggalkan Mina sebelum Maghrib', jenis: JenisAmalan.pilihan, hariDzulhijjah: 12, urutan: 4, dependsOnAmalanId: 'aqabah_12'),
    Amalan(
      id: 'mabit_mina_12',
      nama: 'Mabit di Mina malam 13 Dzulhijjah',
      deskripsi: 'Bagi yang tidak mengambil Nafar Awal.\n\nKetentuan:\nMenghabiskan sebagian besar malam di Mina, Jika dari terbenam matahari hingga terbit fajar 12 jam, maka wajib berada di Mina minimal 6 jam atau lebih sedikit',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 12,
      urutan: 5,
      dependsOnAmalanId: 'aqabah_12',
    ),
    Amalan(id: 'tinggal_mina_12', nama: 'Meninggalkan Mina', deskripsi: 'Dilakukan sebelum Maghrib bagi yang Nafar Awal', jenis: JenisAmalan.wajib, hariDzulhijjah: 12, urutan: 6, dependsOnAmalanId: 'nafar_awal_12'),
  ];

  static const List<Amalan> amalan13Dzulhijjah = [
    Amalan(
      id: 'ula_13',
      nama: 'Lontar Jumrah Ula (Sughra)',
      deskripsi: '7 batu setelah Dzuhur, berdoa setelahnya.\n\nSunnah Ketika melempar jumrah ula:\n1. Ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\n2. Setelah melempar jumroh ula disunnahkan untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 13,
      urutan: 1,
      waktuTrigger: 'dhuhr',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(
      id: 'wustha_13',
      nama: 'Lontar Jumrah Wustha',
      deskripsi: '7 batu setelah Ula, berdoa setelahnya.\n\nSunnah Ketika melempar jumrah wustho:\n1. Ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\n2. Setelah melempar jumroh wustho disunnahkan untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 13,
      urutan: 2,
      dependsOnAmalanId: 'ula_13',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(
      id: 'aqabah_13',
      nama: 'Lontar Jumrah Aqabah (Kubra)',
      deskripsi: '7 batu, tidak berdoa setelahnya.\n\nKetentuan :\nDisunnahkan ketika melempar menjadikan posisi Makkah berada di sebelah kiri dan Mina di sebelah kanan\nTidak disunnahkan Setelah melempar jumroh aqabah untuk berdoa dengan menghadap ke arah kiblat.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 13,
      urutan: 3,
      dependsOnAmalanId: 'wustha_13',
      waktuKeterangan: 'Mulai : Dzuhur\nBerakhir : Sebelum terbit fajar keesokan harinya',
    ),
    Amalan(id: 'tinggal_mina_13', nama: 'Meninggalkan Mina', deskripsi: 'Setelah selesai lontar', jenis: JenisAmalan.wajib, hariDzulhijjah: 13, urutan: 4, dependsOnAmalanId: 'aqabah_13'),
  ];

  static const List<Amalan> amalanPulang = [
    Amalan(
      id: 'thawaf_wada',
      nama: 'Thawaf Wada\'',
      deskripsi: 'Amalan terakhir sebelum pulang.\n\nKetentuan :\n- Thawaf wada’ tidaklah boleh dilakukan melainkan setelah manasik sempurna seperti melempar jumrah pada hari tasyrik dan hendak meninggalkan Makkah (tidak berkaitan dengan tanggal tetapi berdasarkan kapan akan meninggalkan Makkah)\n- Tidaklah masalah menunggu setelah thawaf wada’ untuk persiapan safar, menunggu rombongan, berpamitan, menyiapkan kendaraan, yang penting bukan memilih untuk menetap lagi di Makkah setelah itu\n- Wanita haidh termasuk mendapat uzur meninggalkan thawaf wada’ karena wanita haidh tidaklah diperkenankan untuk shalat dan thawaf. Jika wanita haidh tidak thawaf wada’, maka tidaklah kena kewajiban apa pun. Wanita haidh pun tidaklah mesti menunggu hingga suci.',
      jenis: JenisAmalan.wajib,
      hariDzulhijjah: 99,
      urutan: 1,
    ),
  ];

  static const List<Amalan> allAmalan = [
    ...amalan8Dzulhijjah,
    ...amalan9Dzulhijjah,
    ...amalan10Dzulhijjah,
    ...amalan11Dzulhijjah,
    ...amalan12Dzulhijjah,
    ...amalan13Dzulhijjah,
    ...amalanPulang,
  ];
}
