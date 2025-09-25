import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedToday;
    final habitColor = Color(habit.color);
    
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Card(
          elevation: isCompleted ? 1 : 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isCompleted 
                  ? Border.all(color: habitColor, width: 2)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icono del hábito
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? habitColor.withOpacity(0.2)
                          : habitColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: isCompleted
                          ? Border.all(color: habitColor, width: 1.5)
                          : null,
                    ),
                    child: Icon(
                      habit.icon,
                      color: habitColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Información del hábito
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted 
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted
                                ? Colors.grey[600]
                                : null,
                          ),
                        ),
                        if (habit.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            habit.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        
                        // Información adicional
                        Row(
                          children: [
                            // Racha
                            if (habit.streak > 0) ...[
                              Icon(
                                Icons.local_fire_department,
                                size: 16,
                                color: Colors.orange[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${habit.streak} días',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.orange[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            
                            // Hora de recordatorio
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(habit.reminderTime),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Botón de completar
                  GestureDetector(
                    onTap: onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? habitColor
                            : Colors.transparent,
                        border: Border.all(
                          color: habitColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}