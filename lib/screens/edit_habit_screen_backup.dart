import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../providers/premium_provider.dart';
import '../screens/paywall_screen.dart';
import '../generated/l10n/app_localizations.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  IconData _selectedIcon = HabitIcons.icons[0];
  int _selectedColor = HabitIcons.colors[0];
  FrequencyType _selectedFrequencyType = FrequencyType.daily;
  Set<int> _selectedDays = {1, 2, 3, 4, 5, 6, 7}; // Para custom
  int _weeklyTarget = 3; // Para weekly (default 3 días/semana)
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newHabit),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveHabit,
              child: Text(AppLocalizations.of(context)!.save),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBasicInfo(),
            const SizedBox(height: 24),
            _buildIconSelection(),
            const SizedBox(height: 24),
            _buildColorSelection(),
            const SizedBox(height: 24),
            _buildFrequencySelection(),
            const SizedBox(height: 24),
            _buildReminderTime(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.basicInformation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.habitNameLabel,
                hintText: AppLocalizations.of(context)!.habitNameHint,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterName;
                }
                if (value.trim().length < 2) {
                  return AppLocalizations.of(context)!.nameMinTwoCharacters;
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.descriptionOptional,
                hintText: AppLocalizations.of(context)!.descriptionHint,
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.icon,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: HabitIcons.icons.map((icon) {
                final isSelected = icon == _selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Color(_selectedColor).withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      border: Border.all(
                        color: isSelected
                            ? Color(_selectedColor)
                            : Colors.grey.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? Color(_selectedColor)
                          : Colors.grey[600],
                      size: 28,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.color,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: HabitIcons.colors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(color),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(color).withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.frequencyType,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.selectFrequencyType,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            // Selector de tipo de frecuencia (4 opciones)
            _buildFrequencyTypeOption(
              FrequencyType.daily,
              Icons.today,
              AppLocalizations.of(context)!.frequencyTypeDaily,
              AppLocalizations.of(context)!.dailyDescription,
            ),
            const SizedBox(height: 8),
            _buildFrequencyTypeOption(
              FrequencyType.weekdays,
              Icons.work,
              AppLocalizations.of(context)!.frequencyTypeWeekdays,
              AppLocalizations.of(context)!.weekdaysDescription,
            ),
            const SizedBox(height: 8),
            _buildFrequencyTypeOption(
              FrequencyType.custom,
              Icons.calendar_month,
              AppLocalizations.of(context)!.frequencyTypeCustom,
              AppLocalizations.of(context)!.customDescription,
            ),
            const SizedBox(height: 8),
            _buildFrequencyTypeOption(
              FrequencyType.weekly,
              Icons.repeat,
              AppLocalizations.of(context)!.frequencyTypeWeekly,
              AppLocalizations.of(context)!.weeklyDescription,
            ),
            const SizedBox(height: 16),
            // Mostrar selector de días si es custom
            if (_selectedFrequencyType == FrequencyType.custom)
              _buildCustomDaysSelector(),
            // Mostrar slider si es weekly
            if (_selectedFrequencyType == FrequencyType.weekly)
              _buildWeeklyTargetSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyTypeOption(
    FrequencyType type,
    IconData icon,
    String title,
    String description,
  ) {
    final isSelected = _selectedFrequencyType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFrequencyType = type;
          // Ajustar días seleccionados según el tipo
          if (type == FrequencyType.daily) {
            _selectedDays = {1, 2, 3, 4, 5, 6, 7};
          } else if (type == FrequencyType.weekdays) {
            _selectedDays = {1, 2, 3, 4, 5};
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Color(_selectedColor)
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Color(_selectedColor).withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Color(_selectedColor) : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Color(_selectedColor) : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color(_selectedColor),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDaysSelector() {
    const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final dayNames = [
      AppLocalizations.of(context)!.mondayFull,
      AppLocalizations.of(context)!.tuesdayFull,
      AppLocalizations.of(context)!.wednesdayFull,
      AppLocalizations.of(context)!.thursdayFull,
      AppLocalizations.of(context)!.fridayFull,
      AppLocalizations.of(context)!.saturdayFull,
      AppLocalizations.of(context)!.sundayFull,
    ];

    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final dayNumber = index + 1;
            final isSelected = _selectedDays.contains(dayNumber);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(dayNumber);
                  } else {
                    _selectedDays.add(dayNumber);
                  }
                });
              },
              child: Tooltip(
                message: dayNames[index],
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Color(_selectedColor)
                        : Colors.grey.withOpacity(0.2),
                    border: Border.all(
                      color: isSelected
                          ? Color(_selectedColor)
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      days[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildWeeklyTargetSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.selectDaysPerWeek,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _weeklyTarget.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: AppLocalizations.of(context)!.targetDaysPerWeek(_weeklyTarget),
                activeColor: Color(_selectedColor),
                onChanged: (value) {
                  setState(() {
                    _weeklyTarget = value.toInt();
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(_selectedColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(_selectedColor)),
              ),
              child: Text(
                '$_weeklyTarget',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(_selectedColor),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.timesPerWeek(_weeklyTarget),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTime() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.reminder,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.schedule, color: Color(_selectedColor)),
              title: Text(AppLocalizations.of(context)!.reminderTime),
              subtitle: Text(_formatTimeOfDay(_reminderTime)),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: _selectTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar según el tipo de frecuencia
    if (_selectedFrequencyType == FrequencyType.custom && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectAtLeastOneDay),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Verificar límite de hábitos
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
    final currentHabitCount = habitProvider.habits.length;

    if (!premiumProvider.canAddMoreHabits(currentHabitCount)) {
      _showHabitLimitDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Determinar frequency list según el tipo
      List<int> frequencyList;
      switch (_selectedFrequencyType) {
        case FrequencyType.daily:
          frequencyList = [1, 2, 3, 4, 5, 6, 7];
          break;
        case FrequencyType.weekdays:
          frequencyList = [1, 2, 3, 4, 5];
          break;
        case FrequencyType.custom:
          frequencyList = _selectedDays.toList()..sort();
          break;
        case FrequencyType.weekly:
          frequencyList = [1, 2, 3, 4, 5, 6, 7]; // Para weekly, frequency no importa
          break;
      }

      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        frequencyType: _selectedFrequencyType,
        frequency: frequencyList,
        weeklyTarget: _selectedFrequencyType == FrequencyType.weekly ? _weeklyTarget : null,
        reminderTime: _reminderTime,
        createdAt: DateTime.now(),
        completions: {},
        streak: 0,
        isActive: true,
      );

      await habitProvider.addHabit(habit);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.habitCreatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.genericError}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showHabitLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.habitLimitReached),
        content: Text(
          AppLocalizations.of(context)!.habitLimitMessage(
            PremiumProvider.maxFreeHabits,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaywallScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.upgradeToPro),
          ),
        ],
      ),
    );
  }
}