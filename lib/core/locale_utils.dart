import 'package:flutter/material.dart';

/// Set of Indonesian language and regional languages in Indonesia.
const Set<String> kIndonesianRegionalLanguageCodes = {
  'id', // Bahasa Indonesia
  'jv', // Basa Jawa
  'su', // Basa Sunda
  'min', // Bahaso Minangkabau
  'nia', // Li Niha (Nias)
  'ban', // Basa Bali
  'ace', // Bahsa Acèh
  'bug', // Basa Ugi (Bugis)
  'bjn', // Bahasa Banjar
  'mad', // Basa Madhurâ
  'gor', // Bahasa Gorontalo
  'bew', // Bahasa Betawi
  'map-bms', // Basa Banyumasan
  'mak', // Basa Mangkasara
  'bbc', // Batak Toba
  'btk', // Batak
};

/// Returns true if the provided [langCode] corresponds to Indonesian
/// or an Indonesian regional/local language.
bool isIndonesianRegionLanguage(String langCode) {
  return kIndonesianRegionalLanguageCodes.contains(langCode.trim().toLowerCase());
}

/// Resolves the UI [Locale] based on the active Wikimedia language code.
/// Regional Indonesian languages resolve to 'id'. Other languages (e.g. 'th', 'vi', 'tet', 'tl', 'en') resolve to 'en'.
Locale resolveAppLocale(String langCode) {
  if (isIndonesianRegionLanguage(langCode)) {
    return const Locale('id');
  }
  return const Locale('en');
}
