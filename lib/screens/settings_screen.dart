import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/premium_provider.dart';
import '../providers/notification_settings_provider.dart';
import '../generated/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.themes,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return Column(
                          children: [
                            // Modo de tema
                            ListTile(
                              leading: Icon(
                                Icons.brightness_6,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(AppLocalizations.of(context)!.themeMode),
                              subtitle: Text(themeProvider.getThemeModeName(themeProvider.themeMode, context)),
                              trailing: DropdownButton<AppThemeMode>(
                                value: themeProvider.themeMode,
                                onChanged: (AppThemeMode? newMode) {
                                  if (newMode != null) {
                                    themeProvider.setThemeMode(newMode);
                                  }
                                },
                                items: AppThemeMode.values.map((AppThemeMode mode) {
                                  return DropdownMenuItem<AppThemeMode>(
                                    value: mode,
                                    child: Text(themeProvider.getThemeModeName(mode, context)),
                                  );
                                }).toList(),
                              ),
                            ),
                            const Divider(),
                            // Esquema de colores
                            ListTile(
                              leading: Icon(
                                Icons.color_lens,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(l10n.themes),
                              subtitle: Text(themeProvider.getColorSchemeName(themeProvider.colorScheme, context)),
                            ),
                            const SizedBox(height: 8),
                            // Temas Gratuitos
                            Text(
                              l10n.themes,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: 3, // Only free themes
                              itemBuilder: (context, index) {
                                final scheme = [AppColorScheme.blue, AppColorScheme.green, AppColorScheme.purple][index];
                                final isSelected = themeProvider.colorScheme == scheme;
                                return GestureDetector(
                                  onTap: () => themeProvider.setColorScheme(scheme),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _getSchemeColor(scheme),
                                      shape: BoxShape.circle,
                                      border: isSelected
                                          ? Border.all(
                                              color: Theme.of(context).primaryColor,
                                              width: 3,
                                            )
                                          : null,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            // Botón Premium Temporal (para testing)
                            if (!themeProvider.isPremiumUser)
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
                                  await premiumProvider.grantPremium('testing');
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.premiumTestingActivated),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.star),
                                label: Text(l10n.activatePremium),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                ),
                              ),

                            // Temas Premium
                            Row(
                              children: [
                                Text(
                                  l10n.premiumThemes,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    l10n.premiumPrice,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Premium Themes Grid
                            Column(
                              children: [
                                AppColorScheme.executiveMinimalist,
                                AppColorScheme.neonCyber,
                                AppColorScheme.auroraInspiration,
                                AppColorScheme.zenGarden,
                                AppColorScheme.glassmorphism,
                                AppColorScheme.neumorphism,
                              ].map((scheme) {
                                final isSelected = themeProvider.colorScheme == scheme;
                                final isPremium = themeProvider.isThemePremium(scheme);
                                final canSelect = themeProvider.isPremiumUser || !isPremium;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Card(
                                    elevation: isSelected ? 4 : 1,
                                    color: isSelected ? Theme.of(context).primaryColor.withValues(alpha:0.1) : null,
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: _getSchemeColor(scheme),
                                          shape: BoxShape.circle,
                                          border: isSelected
                                              ? Border.all(
                                                  color: Theme.of(context).primaryColor,
                                                  width: 2,
                                                )
                                              : null,
                                        ),
                                        child: isSelected
                                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                                            : (isPremium && !themeProvider.isPremiumUser)
                                                ? const Icon(Icons.lock, color: Colors.white, size: 20)
                                                : null,
                                      ),
                                      title: Text(
                                        themeProvider.getColorSchemeName(scheme, context),
                                        style: TextStyle(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: canSelect ? null : Colors.grey,
                                        ),
                                      ),
                                      trailing: isPremium
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'PRO',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : null,
                                      onTap: canSelect
                                          ? () => themeProvider.setColorScheme(scheme)
                                          : () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('🔒 ${l10n.premiumThemesOnly}'),
                                                  backgroundColor: Colors.amber[700],
                                                  action: SnackBarAction(
                                                    label: l10n.activatePremium,
                                                    textColor: Colors.black,
                                                    onPressed: () async {
                                                      final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
                                                      await premiumProvider.grantPremium('testing');
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Notifications Section
            _buildNotificationsSection(context, l10n),

            const SizedBox(height: 20),

            // Language Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.language,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
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
                              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                              elevation: isSelected ? 4 : 0,
                              child: ListTile(
                                leading: Icon(
                                  Icons.check_circle,
                                  color: isSelected ? Colors.white : Colors.transparent,
                                ),
                                title: Text(
                                  languageName,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Theme.of(context).textTheme.titleMedium?.color,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                  _getLanguageNativeName(locale.languageCode),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white.withValues(alpha:0.9) : Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : null,
                                onTap: () async {
                                  await localeProvider.setLocaleByCode(locale.languageCode);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.languageChangedTo(languageName)),
                                        backgroundColor: Theme.of(context).primaryColor,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'App Information',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
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

  Color _getSchemeColor(AppColorScheme scheme) {
    switch (scheme) {
      // Free themes
      case AppColorScheme.blue:
        return Colors.blue;
      case AppColorScheme.green:
        return Colors.green;
      case AppColorScheme.purple:
        return Colors.purple;

      // Premium themes
      case AppColorScheme.executiveMinimalist:
        return const Color(0xFF3498db); // Professional Blue
      case AppColorScheme.neonCyber:
        return const Color(0xFF00ffff); // Electric Cyan
      case AppColorScheme.auroraInspiration:
        return const Color(0xFFff69b4); // Aurora Pink
      case AppColorScheme.zenGarden:
        return const Color(0xFF87ceeb); // Sage Green
      case AppColorScheme.glassmorphism:
        return const Color(0xFF4c83ff); // Vivid Blue
      case AppColorScheme.neumorphism:
        return const Color(0xFF667eea); // Soft Blue
    }
  }

  Widget _buildNotificationsSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.notifications,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<NotificationSettingsProvider>(
              builder: (context, notifSettings, child) {
                return Column(
                  children: [
                    // Enable/Disable Notifications
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active),
                      title: Text(l10n.enableNotifications),
                      subtitle: Text(l10n.notificationsDescription),
                      value: notifSettings.notificationsEnabled,
                      onChanged: (value) {
                        notifSettings.setNotificationsEnabled(value);
                      },
                    ),
                    const Divider(),

                    // Default Reminder Time
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(l10n.defaultReminderTime),
                      subtitle: Text(
                        '${notifSettings.defaultReminderTime.hour}:${notifSettings.defaultReminderTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: notifSettings.notificationsEnabled
                          ? () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: notifSettings.defaultReminderTime,
                              );
                              if (picked != null) {
                                notifSettings.setDefaultReminderTime(picked);
                              }
                            }
                          : null,
                    ),
                    const Divider(),

                    // Reminder Sound
                    ListTile(
                      leading: const Icon(Icons.volume_up),
                      title: Text(l10n.reminderSound),
                      subtitle: Text(_getSoundLabel(notifSettings.reminderSound, l10n)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: notifSettings.notificationsEnabled
                          ? () {
                              _showSoundPickerDialog(context, notifSettings, l10n);
                            }
                          : null,
                    ),
                    const Divider(),

                    // Vibration
                    SwitchListTile(
                      secondary: const Icon(Icons.vibration),
                      title: Text(l10n.vibration),
                      value: notifSettings.vibrationEnabled,
                      onChanged: notifSettings.notificationsEnabled
                          ? (value) {
                              notifSettings.setVibrationEnabled(value);
                            }
                          : null,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getSoundLabel(String sound, AppLocalizations l10n) {
    switch (sound) {
      case 'default':
        return l10n.soundDefault;
      case 'none':
        return l10n.soundNone;
      case 'chime':
        return l10n.soundChime;
      case 'bell':
        return l10n.soundBell;
      default:
        return l10n.soundDefault;
    }
  }

  void _showSoundPickerDialog(
    BuildContext context,
    NotificationSettingsProvider notifSettings,
    AppLocalizations l10n,
  ) {
    final sounds = [
      {'value': 'default', 'label': l10n.soundDefault},
      {'value': 'none', 'label': l10n.soundNone},
      {'value': 'chime', 'label': l10n.soundChime},
      {'value': 'bell', 'label': l10n.soundBell},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reminderSound),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sounds.map((sound) {
            final isSelected = notifSettings.reminderSound == sound['value'];
            return RadioListTile<String>(
              title: Text(sound['label']!),
              value: sound['value']!,
              groupValue: notifSettings.reminderSound,
              selected: isSelected,
              onChanged: (value) {
                if (value != null) {
                  notifSettings.setReminderSound(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}