import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/presentation/widgets/animated_checkbox.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _completionController;
  late final Animation<double> _tiltX;
  late final Animation<double> _tiltY;
  late final Animation<double> _tiltZ;
  late final Animation<double> _scale;
  late final Animation<double> _lift;
  late final Animation<double> _glow;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _sheenTravel;

  @override
  void initState() {
    super.initState();
    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    _tiltX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -0.16),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.16, end: 0.08),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.08, end: 0.0),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeOutCubic,
      ),
    );
    _tiltY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.09),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.09, end: -0.03),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.03, end: 0.0),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeOutCubic,
      ),
    );
    _tiltZ = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -0.02),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.02, end: 0.015),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.015, end: 0.0),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeOutCubic,
      ),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.96),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.96, end: 1.015),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.015, end: 1.0),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _lift = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -10.0),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -10.0, end: 3.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 3.0, end: 0.0),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeOutCubic,
      ),
    );
    _glow = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 60,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeOut,
      ),
    );
    _contentOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.84),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.84, end: 0.96),
        weight: 62,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeOutCubic,
      ),
    );
    _sheenTravel = Tween<double>(
      begin: -1.35,
      end: 1.35,
    ).animate(
      CurvedAnimation(
        parent: _completionController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.task.completed && widget.task.completed) {
      _playCompletionAnimation();
    }
    if (oldWidget.task.completed && !widget.task.completed) {
      _completionController.reset();
    }
  }

  @override
  void dispose() {
    _completionController.dispose();
    super.dispose();
  }

  Future<void> _playCompletionAnimation() async {
    if (_completionController.isAnimating) {
      return;
    }
    await _completionController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final dueDate = task.dueDate == null ? null : _formatDueDate(task.dueDate!);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedBuilder(
        animation: _completionController,
        builder: (context, child) {
          final tiltTransform = Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(_tiltX.value)
            ..rotateY(_tiltY.value)
            ..rotateZ(_tiltZ.value);

          final animatedShadow = BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.10 * _glow.value),
            blurRadius: 28 * _glow.value,
            spreadRadius: 1.5 * _glow.value,
            offset: Offset(0, 10 * _glow.value),
          );

          return Transform(
            alignment: Alignment.center,
            transform: tiltTransform,
            child: Transform.translate(
              offset: Offset(0, _lift.value + (_pressed ? 2.0 : 0.0)),
              child: Transform.scale(
                scale: _scale.value,
                child: Opacity(
                  opacity: task.completed ? _contentOpacity.value : 1,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.circular(context, 26),
                          boxShadow: [
                            if (!_pressed) ...AppColors.softShadow,
                            if (_glow.value > 0) animatedShadow,
                          ],
                        ),
                        child: child,
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: _glow.value * 0.9,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.accent.withValues(alpha: 0.18),
                                    AppColors.primary.withValues(alpha: 0.06),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: AppSpacing.circular(context, 26),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: ClipRRect(
                            borderRadius: AppSpacing.circular(context, 26),
                            child: Align(
                              alignment: Alignment(_sheenTravel.value, 0),
                              child: Opacity(
                                opacity: _glow.value * 0.5,
                                child: Transform.rotate(
                                  angle: -0.24,
                                  child: Container(
                                    width: AppSpacing.value(context, 108),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0),
                                          Colors.white.withValues(alpha: 0.48),
                                          Colors.white.withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: AppConstants.fastAnimation,
          curve: Curves.easeOut,
          padding: AppSpacing.all(context, 18),
          decoration: BoxDecoration(
            color: task.completed ? AppColors.completed : Colors.white,
            borderRadius: AppSpacing.circular(context, 26),
            border: Border.all(
              color: task.completed
                  ? AppColors.completed
                  : task.isOverdue
                      ? AppColors.warning.withValues(alpha: 0.4)
                      : AppColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppSpacing.only(context: context, top: 2),
                child: AnimatedCheckbox(
                  value: task.completed,
                  onTap: widget.onToggle,
                ),
              ),
              AppSpacing.w(context, 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: AppConstants.fastAnimation,
                      style: AppTypography.textTheme.titleMedium!.copyWith(
                        color: task.completed
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      child: Text(task.title),
                    ),
                    if (task.hasDescription) ...[
                      AppSpacing.h(context, 8),
                      AnimatedOpacity(
                        duration: AppConstants.fastAnimation,
                        opacity: task.completed ? 0.72 : 1,
                        child: Text(
                          task.description!,
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                    AppSpacing.h(context, 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TaskMetaChip(
                          icon: Icons.schedule_rounded,
                          label: dueDate ?? 'No due date',
                          color: task.isOverdue
                              ? AppColors.warning
                              : AppColors.info,
                        ),
                        _TaskMetaChip(
                          icon: task.completed
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          label: task.completed ? 'Completed' : 'In progress',
                          color: task.completed
                              ? AppColors.accent
                              : AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.w(context, 8),
              Column(
                children: [
                  IconButton(
                    onPressed: widget.onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: AppColors.danger,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime dateTime) {
    final dateLabel = DateFormat('dd MMM').format(dateTime);
    final hasTime = dateTime.hour != 0 || dateTime.minute != 0;
    if (!hasTime) {
      return dateLabel;
    }
    return '$dateLabel - ${DateFormat('hh:mm a').format(dateTime)}';
  }
}

class _TaskMetaChip extends StatelessWidget {
  const _TaskMetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(
        context: context,
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.circular(context, 999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          AppSpacing.w(context, 6),
          Text(
            label,
            style: AppTypography.textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
