import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../core/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Settings'), // Will be localized later
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Section
            Card(
              color: AppColors.surfaceDark,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Language / Idioma / Sprache',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Consumer<LocaleProvider>(
                      builder: (context, localeProvider, child) {
                        return Column(
                          children: LocaleProvider.supportedLocales.map((locale) {
                            final isSelected = localeProvider.currentLanguageCode == locale.languageCode;
                            final languageName = LocaleProvider.getLanguageName(locale.languageCode);

                            return Card(
                              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                              elevation: isSelected ? 2 : 0,
                              child: ListTile(
                                leading: Icon(
                                  Icons.check_circle,
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                ),
                                title: Text(
                                  languageName,
                                  style: TextStyle(
                                    color: isSelected ? AppColors.primary : AppColors.textDark,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                  _getLanguageNativeName(locale.languageCode),
                                  style: TextStyle(
                                    color: isSelected ? AppColors.primary.withOpacity(0.8) : AppColors.textSecondaryDark,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Icon(
                                        Icons.star,
                                        color: AppColors.primary,
                                        size: 20,
                                      )
                                    : null,
                                onTap: () async {
                                  await localeProvider.setLocaleByCode(locale.languageCode);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Language changed to $languageName'),
                                        backgroundColor: AppColors.primary,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // App Info Section
            Card(
              color: AppColors.surfaceDark,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'App Information',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile('App Name', l10n.appTitle),
                    _buildInfoTile('Version', '1.0.0'),
                    _buildInfoTile('Current Language', context.read<LocaleProvider>().currentLanguageName),
                    _buildInfoTile('Supported Languages', '${LocaleProvider.supportedLocales.length} languages'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Test Section
            Card(
              color: AppColors.surfaceDark,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.science,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Localization Test',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Localized strings test:', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('• ${l10n.appTitle}', style: TextStyle(color: AppColors.textDark)),
                          Text('• ${l10n.today}', style: TextStyle(color: AppColors.textDark)),
                          Text('• ${l10n.save}', style: TextStyle(color: AppColors.textDark)),
                          Text('• ${l10n.cancel}', style: TextStyle(color: AppColors.textDark)),
                          Text('• ${l10n.loading}', style: TextStyle(color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageNativeName(String languageCode) {
    switch (languageCode) {
      // Phase 1: Core Global Languages
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'zh':
        return '中文';

      // Phase 2A: European Expansion
      case 'it':
        return 'Italiano';
      case 'nl':
        return 'Nederlands';
      case 'sv':
        return 'Svenska';
      case 'pl':
        return 'Polski';
      case 'pt':
        return 'Português';
      case 'ro':
        return 'Română';
      case 'cs':
        return 'Čeština';
      case 'da':
        return 'Dansk';
      case 'no':
        return 'Norsk';
      case 'fi':
        return 'Suomi';

      // Phase 2B: Asian & Strategic Markets
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'hi':
        return 'हिन्दी';
      case 'bn':
        return 'বাংলা';
      case 'th':
        return 'ไทย';
      case 'vi':
        return 'Tiếng Việt';
      case 'id':
        return 'Bahasa Indonesia';
      case 'tl':
        return 'Filipino';
      case 'ar':
        return 'العربية';
      case 'tr':
        return 'Türkçe';
      case 'ru':
        return 'Русский';

      default:
        return languageCode.toUpperCase();
    }
  }
}