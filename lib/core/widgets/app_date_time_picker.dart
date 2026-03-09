import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';
import 'package:to_do_app/core/widgets/app_button.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';

class AppDateTimePicker extends StatelessWidget {
  const AppDateTimePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    final quickPicks = <_QuickPickOption>[
      _QuickPickOption(
        label: 'Today',
        date: _startOfDay(DateTime.now()),
      ),
      _QuickPickOption(
        label: 'Tomorrow',
        date: _startOfDay(DateTime.now().add(const Duration(days: 1))),
      ),
      _QuickPickOption(
        label: 'Next Week',
        date: _startOfDay(DateTime.now().add(const Duration(days: 7))),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.textTheme.labelLarge),
        AppSpacing.h(context, 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppSpacing.circular(context, 28),
            onTap: () => _openPicker(context),
            child: AnimatedContainer(
              duration: AppConstants.fastAnimation,
              padding: AppSpacing.all(context, 18),
              decoration: BoxDecoration(
                gradient: hasValue
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          AppColors.secondary.withValues(alpha: 0.06),
                        ],
                      )
                    : const LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ),
                borderRadius: AppSpacing.circular(context, 28),
                border: Border.all(
                  color: hasValue
                      ? AppColors.secondary.withValues(alpha: 0.2)
                      : AppColors.border,
                ),
                boxShadow: [
                  ...AppColors.softShadow,
                  if (hasValue)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: AppSpacing.value(context, 54),
                    width: AppSpacing.value(context, 54),
                    decoration: BoxDecoration(
                      gradient: hasValue
                          ? AppColors.primaryGradient
                          : LinearGradient(
                              colors: [
                                AppColors.surfaceSoft,
                                AppColors.info.withValues(alpha: 0.08),
                              ],
                            ),
                      borderRadius: AppSpacing.circular(context, 18),
                    ),
                    child: Icon(
                      hasValue
                          ? Icons.event_available_rounded
                          : Icons.calendar_month_rounded,
                      color: hasValue ? Colors.white : AppColors.info,
                    ),
                  ),
                  AppSpacing.w(context, 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasValue ? _headline(value!) : 'Pick a due date',
                          style: AppTypography.textTheme.titleMedium,
                        ),
                        AppSpacing.h(context, 4),
                        Text(
                          hasValue
                              ? _caption(value!)
                              : 'Add a date or specific time for this task',
                          style: AppTypography.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (hasValue)
                    IconButton(
                      tooltip: 'Clear',
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        onChanged(null);
                      },
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textSecondary,
                    ),
                  Container(
                    height: AppSpacing.value(context, 36),
                    width: AppSpacing.value(context, 36),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: AppSpacing.circular(context, 12),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AppSpacing.h(context, 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: quickPicks.map((quickPick) {
            final selected =
                hasValue && _isSameDay(value!, quickPick.date);
            return _QuickPickChip(
              label: quickPick.label,
              selected: selected,
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(quickPick.date);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    HapticFeedback.selectionClick();
    final result = await showModalBottomSheet<_DateTimePickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DateTimePickerSheet(initialValue: value),
    );

    if (result == null) {
      return;
    }

    if (result.cleared) {
      onChanged(null);
      return;
    }

    onChanged(result.value);
  }

  static bool _hasExplicitTime(DateTime dateTime) {
    return dateTime.hour != 0 || dateTime.minute != 0;
  }

  static String _headline(DateTime dateTime) {
    final dateText = DateFormat('EEE, dd MMM yyyy').format(dateTime);
    if (_hasExplicitTime(dateTime)) {
      return '$dateText • ${DateFormat('hh:mm a').format(dateTime)}';
    }
    return dateText;
  }

  static String _caption(DateTime dateTime) {
    final now = DateTime.now();
    final today = _startOfDay(now);
    final target = _startOfDay(dateTime);
    final difference = target.difference(today).inDays;

    final relativeLabel = switch (difference) {
      0 => 'Today',
      1 => 'Tomorrow',
      -1 => 'Yesterday',
      _ when difference > 1 => 'In $difference days',
      _ => '${difference.abs()} days ago',
    };

    return _hasExplicitTime(dateTime)
        ? '$relativeLabel • Time locked in'
        : '$relativeLabel • Any time';
  }

  static DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class _DateTimePickerSheet extends StatefulWidget {
  const _DateTimePickerSheet({required this.initialValue});

  final DateTime? initialValue;

  @override
  State<_DateTimePickerSheet> createState() => _DateTimePickerSheetState();
}

class _DateTimePickerSheetState extends State<_DateTimePickerSheet> {
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final initial = widget.initialValue ?? now;
    _selectedDate = DateTime(initial.year, initial.month, initial.day);
    if (initial.hour != 0 || initial.minute != 0) {
      _selectedTime = TimeOfDay.fromDateTime(initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedDateTime = _resolvedDateTime();

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: AppSpacing.verticalRadius(context, top: 36),
        ),
        child: Padding(
          padding: AppSpacing.fromLTRBWithBottomInset(
            context,
            left: 20,
            top: 12,
            right: 20,
            bottom: 20,
            bottomInset: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: AppSpacing.value(context, 56),
                  height: AppSpacing.value(context, 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7DBE5),
                    borderRadius: AppSpacing.circular(context, 999),
                  ),
                ),
              ),
              AppSpacing.h(context, 20),
              Text(
                'Schedule task timing',
                style: AppTypography.textTheme.headlineMedium,
              ),
              AppSpacing.h(context, 8),
              Text(
                'Pick a date, then optionally lock in a time.',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.h(context, 18),
              _SelectionPreview(
                dateTime: resolvedDateTime,
                hasExplicitTime: _selectedTime != null,
              ),
              AppSpacing.h(context, 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _QuickPickChip(
                    label: 'Today',
                    selected: AppDateTimePicker._isSameDay(
                      _selectedDate,
                      DateTime.now(),
                    ),
                    onTap: () => _jumpTo(DateTime.now()),
                  ),
                  _QuickPickChip(
                    label: 'Tomorrow',
                    selected: AppDateTimePicker._isSameDay(
                      _selectedDate,
                      DateTime.now().add(const Duration(days: 1)),
                    ),
                    onTap: () => _jumpTo(
                      DateTime.now().add(const Duration(days: 1)),
                    ),
                  ),
                  _QuickPickChip(
                    label: 'Next Week',
                    selected: AppDateTimePicker._isSameDay(
                      _selectedDate,
                      DateTime.now().add(const Duration(days: 7)),
                    ),
                    onTap: () => _jumpTo(
                      DateTime.now().add(const Duration(days: 7)),
                    ),
                  ),
                ],
              ),
              AppSpacing.h(context, 18),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppSpacing.circular(context, 28),
                  boxShadow: AppColors.softShadow,
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                  onDateChanged: (date) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedDate = date);
                  },
                ),
              ),
              AppSpacing.h(context, 18),
              _TimeSelectorRow(
                selectedTime: _selectedTime,
                onSelect: _pickTime,
                onClear: _selectedTime == null
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedTime = null);
                      },
              ),
              AppSpacing.h(context, 20),
              Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      label: 'Clear',
                      expand: true,
                      variant: ButtonVariant.secondary,
                      onPressed: () {
                        Navigator.of(context).pop(
                          const _DateTimePickerResult(cleared: true),
                        );
                      },
                    ),
                  ),
                  AppSpacing.w(context, 12),
                  Expanded(
                    child: GradientButton(
                      label: 'Save',
                      expand: true,
                      onPressed: () {
                        Navigator.of(context).pop(
                          _DateTimePickerResult(value: _resolvedDateTime()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _jumpTo(DateTime date) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) {
      return;
    }

    HapticFeedback.selectionClick();
    setState(() => _selectedTime = pickedTime);
  }

  DateTime _resolvedDateTime() {
    if (_selectedTime == null) {
      return DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
    }

    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }
}

class _SelectionPreview extends StatelessWidget {
  const _SelectionPreview({
    required this.dateTime,
    required this.hasExplicitTime,
  });

  final DateTime dateTime;
  final bool hasExplicitTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(context, 18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.circular(context, 28),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Container(
            height: AppSpacing.value(context, 52),
            width: AppSpacing.value(context, 52),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: AppSpacing.circular(context, 18),
            ),
            child: const Icon(Icons.schedule_rounded, color: Colors.white),
          ),
          AppSpacing.w(context, 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, dd MMM yyyy').format(dateTime),
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                AppSpacing.h(context, 4),
                Text(
                  hasExplicitTime
                      ? DateFormat('hh:mm a').format(dateTime)
                      : 'Any time',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSelectorRow extends StatelessWidget {
  const _TimeSelectorRow({
    required this.selectedTime,
    required this.onSelect,
    required this.onClear,
  });

  final TimeOfDay? selectedTime;
  final VoidCallback onSelect;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: AppSpacing.circular(context, 22),
              onTap: onSelect,
              child: Ink(
                padding: AppSpacing.symmetric(
                  context: context,
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppSpacing.circular(context, 22),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      height: AppSpacing.value(context, 40),
                      width: AppSpacing.value(context, 40),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.12),
                        borderRadius: AppSpacing.circular(context, 14),
                      ),
                      child: const Icon(
                        Icons.watch_later_outlined,
                        color: AppColors.info,
                        size: 20,
                      ),
                    ),
                    AppSpacing.w(context, 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: AppTypography.textTheme.labelLarge,
                          ),
                          AppSpacing.h(context, 2),
                          Text(
                            selectedTime == null
                                ? 'Any time'
                                : selectedTime!.format(context),
                            style: AppTypography.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (onClear != null) ...[
          AppSpacing.w(context, 10),
          SizedBox(
            height: AppSpacing.value(context, 56),
            child: GradientButton(
              label: 'Clear',
              expand: false,
              variant: ButtonVariant.secondary,
              onPressed: onClear,
              padding: AppSpacing.symmetric(
                context: context,
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickPickChip extends StatelessWidget {
  const _QuickPickChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppSpacing.circular(context, 999),
        onTap: onTap,
        child: Ink(
          padding: AppSpacing.symmetric(
            context: context,
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryGradient : null,
            color: selected ? null : Colors.white,
            borderRadius: AppSpacing.circular(context, 999),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickPickOption {
  const _QuickPickOption({
    required this.label,
    required this.date,
  });

  final String label;
  final DateTime date;
}

class _DateTimePickerResult {
  const _DateTimePickerResult({
    this.value,
    this.cleared = false,
  });

  final DateTime? value;
  final bool cleared;
}
