import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../generated/l10n/app_localizations.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit habit;

  const EditHabitScreen({
    Key? key,
    required this.habit,
  }) : super(key: key);

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  late IconData _selectedIcon;
  late int _selectedColor;
  late FrequencyType _selectedFrequencyType;
  late Set<int> _selectedDays;
  late int _weeklyTarget;
  late TimeOfDay _reminderTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _descriptionController = TextEditingController(text: widget.habit.description);
    _selectedIcon = widget.habit.icon;
    _selectedColor = widget.habit.color;
    _selectedFrequencyType = widget.habit.frequencyType;
    _selectedDays = widget.habit.frequency.toSet();
    _weeklyTarget = widget.habit.weeklyTarget ?? 3;
    _reminderTime = widget.habit.reminderTime;
  }

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
        title: Text(AppLocalizations.of(context)!.editHabit),
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
              onPressed: _saveChanges,
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
            const SizedBox(height: 24),
            _buildDangerZone(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.basicInformationLabel,
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
                border: const OutlineInputBorder(),
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
                border: const OutlineInputBorder(),
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
      color: Theme.of(context).colorScheme.surfaceContainerLow,
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
                          ? Color(_selectedColor).withValues(alpha:0.2)
                          : Colors.grey.withValues(alpha:0.1),
                      border: Border.all(
                        color: isSelected
                            ? Color(_selectedColor)
                            : Colors.grey.withValues(alpha:0.3),
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
      color: Theme.of(context).colorScheme.surfaceContainerLow,
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
                                color: Color(color).withValues(alpha:0.4),
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
      color: Theme.of(context).colorScheme.surfaceContainerLow,
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
                : Colors.grey.withValues(alpha:0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Color(_selectedColor).withValues(alpha:0.1)
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
                        : Colors.grey.withValues(alpha:0.2),
                    border: Border.all(
                      color: isSelected
                          ? Color(_selectedColor)
                          : Colors.grey.withValues(alpha:0.5),
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
                color: Color(_selectedColor).withValues(alpha:0.1),
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
      color: Theme.of(context).colorScheme.surfaceContainerLow,
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
                side: BorderSide(color: Colors.grey.withValues(alpha:0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone() {
    return Card(
      color: Colors.red.withValues(alpha:0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.red[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.dangerZone,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _deleteHabit,
                icon: const Icon(Icons.delete_outline),
                label: Text(AppLocalizations.of(context)!.deleteHabitButton),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red[700],
                  side: BorderSide(color: Colors.red.withValues(alpha:0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.deleteWarningMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red[600],
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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectAtLeastOneDay),
          backgroundColor: Colors.orange,
        ),
      );
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
          frequencyList = [1, 2, 3, 4, 5, 6, 7];
          break;
      }

      final updatedHabit = widget.habit.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        frequencyType: _selectedFrequencyType,
        frequency: frequencyList,
        weeklyTarget: _selectedFrequencyType == FrequencyType.weekly ? _weeklyTarget : null,
        reminderTime: _reminderTime,
      );

      final habitProvider = Provider.of<HabitProvider>(context, listen: false);
      await habitProvider.updateHabit(updatedHabit);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.habitUpdatedMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.updateError}: $e'),
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

  Future<void> _deleteHabit() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteHabitTitle),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280),
            child: Text(
              AppLocalizations.of(context)!.confirmDeleteHabitMessage(widget.habit.name),
              style: const TextStyle(height: 1.4),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[700],
              ),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final habitProvider = Provider.of<HabitProvider>(context, listen: false);
        await habitProvider.deleteHabit(widget.habit.id);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.habitDeletedMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppLocalizations.of(context)!.deleteError}: $e'),
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
  }
}