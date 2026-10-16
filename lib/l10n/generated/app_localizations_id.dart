// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Wiki Talk';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get submit => 'Kirim';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get close => 'Tutup';

  @override
  String get remove => 'Hapus';

  @override
  String get error => 'Galat';

  @override
  String get apply => 'Terapkan';

  @override
  String get channels => 'Saluran';

  @override
  String get addChannel => 'Tambah Saluran';

  @override
  String get addCustomTalkPage => 'Tambah Halaman Pembicaraan Kustom';

  @override
  String get wikiPageTitle => 'Judul Halaman Wiki';

  @override
  String get wikiPageTitleHint =>
      'contoh: Pembicaraan:Indonesia atau WP:Kedutaan';

  @override
  String get channelDisplayName => 'Nama Tampilan Saluran';

  @override
  String get channelDisplayNameHint => 'contoh: Diskusi Indonesia';

  @override
  String get pageTitleRequired => 'Judul halaman wajib diisi';

  @override
  String get nameRequired => 'Nama wajib diisi';

  @override
  String get customTalkPage => 'Halaman pembicaraan kustom';

  @override
  String get loggedIn => 'Sudah masuk';

  @override
  String get notLoggedIn => 'Belum masuk';

  @override
  String get tapToLogIn => 'Ketuk untuk masuk';

  @override
  String get settings => 'Pengaturan';

  @override
  String get resetDefaults => 'Atur Ulang ke Default';

  @override
  String get resetChannelsSnackBar =>
      'Saluran telah diatur ulang ke default proyek';

  @override
  String get customBadge => 'KUSTOM';

  @override
  String get removeChannel => 'Hapus saluran';

  @override
  String removedChannelSnackBar(String name) {
    return 'Berhasil menghapus \"$name\"';
  }

  @override
  String addedChannelSnackBar(String name) {
    return 'Berhasil menambahkan saluran \"$name\"';
  }

  @override
  String get addSubpageOrChannel => 'Tambah Subhalaman / Saluran';

  @override
  String get searchTopicsHint => 'Cari topik, subjek, atau penulis...';

  @override
  String searchTopicsInChannel(String channel) {
    return 'Cari topik di $channel...';
  }

  @override
  String get loadingDiscussions => 'Memuat diskusi...';

  @override
  String get noDiscussionsFound => 'Tidak ada diskusi ditemukan';

  @override
  String get noDiscussionsInChannel => 'Belum ada diskusi di saluran ini.';

  @override
  String noTopicsMatchQuery(String query) {
    return 'Tidak ada topik yang cocok dengan \"$query\"';
  }

  @override
  String get failedToLoadDiscussions => 'Gagal memuat diskusi';

  @override
  String get newTopic => 'Topik Baru';

  @override
  String newTopicInChannel(String channel) {
    return 'Topik Baru di $channel';
  }

  @override
  String get topicTitleLabel => 'Judul Topik';

  @override
  String get topicTitleHint => 'contoh: Usulan pedoman baru';

  @override
  String get messageBodyLabel => 'Isi Pesan (Mendukung Wikiteks)';

  @override
  String get messageBodyHint => 'Bagikan pemikiran Anda dengan komunitas...';

  @override
  String get publishTopicToWiki => 'Terbitkan Topik ke Wiki';

  @override
  String get selectChannelToView => 'Pilih saluran untuk melihat diskusi';

  @override
  String commentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komentar',
      one: '1 komentar',
      zero: 'Belum ada komentar',
    );
    return '$_temp0';
  }

  @override
  String authorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count penulis',
      one: '1 penulis',
      zero: '0 penulis',
    );
    return '$_temp0';
  }

  @override
  String commentsAndContributors(int comments, int authors) {
    return '$comments komentar · $authors kontributor';
  }

  @override
  String get noCommentsYetBeFirst =>
      'Belum ada komentar dalam utas ini. Jadilah yang pertama membalas!';

  @override
  String get createNewTopic => 'Buat Topik Baru';

  @override
  String get topicSubjectTitle => 'Subjek / Judul Topik';

  @override
  String get topicTitleRequired => 'Judul topik wajib diisi';

  @override
  String get topicMessageContent => 'Isi Pesan';

  @override
  String get topicContentRequired => 'Isi pesan wajib diisi';

  @override
  String get publishTopic => 'Terbitkan Topik';

  @override
  String get topicCreatedSuccess => 'Topik berhasil diterbitkan!';

  @override
  String get selectTopicToRead => 'Pilih topik diskusi untuk mulai membaca';

  @override
  String get noMessagesYet => 'Belum ada pesan dalam diskusi ini.';

  @override
  String get reply => 'Balas';

  @override
  String replyingTo(String author) {
    return 'Membalas @$author';
  }

  @override
  String get cancelReply => 'Batalkan balasan';

  @override
  String get replyPlaceholder =>
      'Tulis balasan atau pesan (mendukung wikiteks)...';

  @override
  String get writeCommentOnWiki => 'Tulis komentar di wiki...';

  @override
  String get bold => 'Tebal';

  @override
  String get italic => 'Miring';

  @override
  String get link => 'Pranala';

  @override
  String get signature => 'Tanda tangan';

  @override
  String get send => 'Kirim';

  @override
  String get loginRequired => 'Wajib Masuk';

  @override
  String get loginRequiredMessage =>
      'Anda harus masuk dengan akun Wikimedia untuk membalas diskusi ini.';

  @override
  String get logIn => 'Masuk';

  @override
  String get loginRequiredToReply =>
      'Silakan masuk dengan akun Wikimedia untuk membalas diskusi.';

  @override
  String get replySentSuccess => 'Balasan berhasil dikirim!';

  @override
  String get projectAndLanguage => 'Proyek & Bahasa';

  @override
  String get wikimediaProject => 'Proyek Wikimedia';

  @override
  String get languageEdition => 'Edisi Bahasa';

  @override
  String get customLanguageCodeHint =>
      'Kode bahasa kustom (misal: su, min, bar)';

  @override
  String get customLanguage => 'Bahasa kustom';

  @override
  String get customLanguageCodeDialogTitle => 'Kode Bahasa Kustom';

  @override
  String get isoLanguageCode => 'Kode Bahasa ISO';

  @override
  String targetDomain(String domain) {
    return 'Domain Target: $domain';
  }

  @override
  String get baseDiscussionPage => 'Halaman Diskusi Utama';

  @override
  String get baseDiscussionPageDesc =>
      'Nama warung kopi, kedutaan, atau portal diskusi dalam proyek/bahasa ini (misal: \"Wikikamus:Monganga afo\" atau \"Wikipedia:Warung Kopi\").';

  @override
  String get basePageTitleLabel =>
      'Judul halaman utama (misal: Wikipedia:Warung Kopi)';

  @override
  String get basePageTitleHint => 'misal: Wikipedia:Warung Kopi';

  @override
  String get channelDescriptionHint => 'misal: Usulan ide baru dari komunitas';

  @override
  String get subpageLabel => 'Subhalaman';

  @override
  String get customLanguageHint => 'misal: th, vi, tet, tl';

  @override
  String get toolbarSupport => 'Setuju';

  @override
  String get toolbarSupportTooltip => 'Lencana setuju';

  @override
  String get toolbarOppose => 'Tolak';

  @override
  String get toolbarOpposeTooltip => 'Lencana tolak';

  @override
  String get toolbarMentionTooltip => 'Sebut pengguna';

  @override
  String get userLabel => 'Pengguna';

  @override
  String timeMinutesAgo(int count) {
    return '$count mnt lalu';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count jam lalu';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count hari lalu';
  }

  @override
  String get mainDiscussionBoardTitle => 'Judul Papan Diskusi Utama';

  @override
  String get applyTargetPageTitle => 'Terapkan Judul Halaman Target';

  @override
  String get set => 'Terapkan';

  @override
  String targetPageSetSnackBar(String title) {
    return 'Halaman target disetel ke \"$title\"';
  }

  @override
  String get resetToDefault => 'Atur Ulang ke Default';

  @override
  String get resetToDefaultSnackBar =>
      'Diatur ulang ke judul halaman default proyek';

  @override
  String get channelsAndSubpages => 'Saluran & Subhalaman';

  @override
  String get channelsSubpagesDesc =>
      'Kelola subhalaman atau halaman diskusi khusus yang muncul sebagai saluran dalam aplikasi.';

  @override
  String get noChannelsConfigured =>
      'Belum ada saluran yang dikonfigurasi. Ketuk di bawah untuk menambahkan.';

  @override
  String get noChannelsConfiguredFull =>
      'Belum ada saluran yang dikonfigurasi.\nKetuk di bawah untuk menambahkan subhalaman atau atur ulang ke default.';

  @override
  String get addDiscussionChannelTitle => 'Tambah Saluran / Subhalaman Diskusi';

  @override
  String get fullOnWikiPageTitle => 'Judul Lengkap Halaman di Wiki';

  @override
  String get channelDescriptionOptional => 'Deskripsi (Opsional)';

  @override
  String get channelIconLabel => 'Ikon';

  @override
  String get appearance => 'Tampilan';

  @override
  String get themeMode => 'Mode Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get accountAndAuthorization => 'Akun & Otorisasi';

  @override
  String get wikimediaAccount => 'Akun Wikimedia';

  @override
  String get guestNotice =>
      'Anda dapat menjelajahi diskusi publik dengan bebas sebagai tamu. Untuk mengirim balasan atau memulai topik baru, masuk dengan akun Wikimedia Anda.';

  @override
  String get connectedViaOAuth => 'Terhubung melalui Wikimedia OAuth 2.0';

  @override
  String get loggedOutNotice =>
      'Belum masuk. Anda dapat membaca diskusi secara bebas. Masuk untuk membalas atau membuat topik baru.';

  @override
  String get loginWithWikimedia => 'Masuk dengan Wikimedia';

  @override
  String get logOut => 'Keluar';

  @override
  String get pageDescriptionOptional => 'Deskripsi Halaman (opsional)';

  @override
  String get channelIcon => 'Ikon Saluran';

  @override
  String get aboutAppTitle => 'Wiki Talk v1.0.0';

  @override
  String get aboutAppDescription =>
      'Pembaca dan penyunting diskusi kolaboratif untuk halaman pembicaraan dan warung kopi komunitas Wikimedia.\n\nKlasifikasi: Alat / Referensi & Produktivitas.\nPenyimpanan: Semua diskusi adalah wikiteks publik di wiki. Tembolok luring disimpan di SQLite perangkat lokal.\nIzin: Hanya Internet untuk MediaWiki API.';

  @override
  String get wikimediaTargetHeader => 'TARGET WIKIMEDIA';

  @override
  String get targetDiscussionPageTitleHeader => 'JUDUL HALAMAN DISKUSI TARGET';

  @override
  String get channelsSubpagesHeader => 'SALURAN & SUBHALAMAN';

  @override
  String get appearanceHeader => 'TAMPILAN';

  @override
  String get wikimediaAccountHeader => 'AKUN WIKIMEDIA';

  @override
  String get aboutComplianceHeader => 'TENTANG & KEPATUHAN';

  @override
  String get captchaSecurityVerification => 'Verifikasi Keamanan (CAPTCHA)';

  @override
  String get captchaVerificationMessage =>
      'MediaWiki memerlukan verifikasi cepat sebelum menerbitkan suntingan ini.';

  @override
  String get captchaEnterText => 'Masukkan teks CAPTCHA';

  @override
  String get captchaAnswerLabel => 'Jawaban / Kata';

  @override
  String get captchaRequired => 'Teks CAPTCHA wajib diisi';

  @override
  String get verifyAndSubmit => 'Verifikasi & Kirim';

  @override
  String get channelPolicy => 'Kebijakan';

  @override
  String get channelPolicyDesc =>
      'Diskusi kebijakan, pedoman, dan tata kelola komunitas';

  @override
  String get channelTechnical => 'Teknis';

  @override
  String get channelTechnicalDesc =>
      'Masalah teknis, bug bot, skrip Lua, dan templat';

  @override
  String get channelProposals => 'Usulan';

  @override
  String get channelProposalsDesc =>
      'Usulan ide baru, fitur, dan proyek komunitas';

  @override
  String get channelIdeaLab => 'Laboratorium Gagasan';

  @override
  String get channelIdeaLabDesc =>
      'Mengembangkan usulan tahap awal sebelum pemungutan suara';

  @override
  String get channelTeahouse => 'Kedai Teh';

  @override
  String get channelTeahouseDesc =>
      'Ruang ramah bagi penyunting baru untuk bertanya';

  @override
  String get channelMisc => 'Lain-lain';

  @override
  String get channelMiscDesc =>
      'Obrolan umum dan topik santai seputar ensiklopedia';

  @override
  String get channelNews => 'Berita';

  @override
  String get channelNewsDesc =>
      'Pengumuman proyek, lomba, warta, dan kabar komunitas';

  @override
  String get channelLanguage => 'Bahasa';

  @override
  String get channelLanguageDesc =>
      'Tata bahasa, istilah terjemahan, dan kaidah KBBI';

  @override
  String get channelCommunityDiscussion => 'Diskusi Komunitas';

  @override
  String channelMainDiscussionBoard(String domain) {
    return 'Papan diskusi utama di $domain';
  }

  @override
  String channelDiscussionPageOn(String domain) {
    return 'Halaman diskusi di $domain';
  }

  @override
  String get failedToLoadCaptchaImage => 'Gagal memuat gambar CAPTCHA.';

  @override
  String get emptyComment => 'Komentar kosong';
}
