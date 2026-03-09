import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';
import 'package:to_do_app/core/utils/form_utils.dart';
import 'package:to_do_app/core/widgets/app_button.dart';
import 'package:to_do_app/core/widgets/app_date_time_picker.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';
import 'package:to_do_app/core/widgets/task_input_field.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';

Future<void> showAddTaskComposer(
  BuildContext context, {
  required ValueChanged<TaskDraft> onSubmit,
  bool isLoading = false,
}) {
  HapticFeedback.selectionClick();
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Add task',
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.18),
    transitionDuration: AppConstants.mediumAnimation,
    pageBuilder: (context, animation, secondaryAnimation) {
      return _AddTaskComposerRoute(
        child: AddTaskSheet(onSubmit: onSubmit, isLoading: isLoading),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  final ValueChanged<TaskDraft> onSubmit;
  final bool isLoading;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    FormUtils.unfocus(context);

    final draft = TaskDraft(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate,
    );

    Navigator.of(context).pop();
    widget.onSubmit(draft);
  }

  @override
  Widget build(BuildContext context) {
    final mergedListenable = Listenable.merge([
      _titleController,
      _descriptionController,
    ]);

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: AppSpacing.value(context, 760)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.98),
              const Color(0xFFF8FAFF),
              const Color(0xFFF4F2FF),
            ],
          ),
          borderRadius: AppSpacing.circular(context, 36),
          border: Border.all(color: AppColors.glassStroke),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.10),
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
            const BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 40,
              offset: Offset(0, -12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppSpacing.circular(context, 36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: AppSpacing.fromLTRB(context, 20, 12, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AppSpacing.value(context, 58),
                              height: AppSpacing.value(context, 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD7DBE5),
                                borderRadius: AppSpacing.circular(context, 999),
                              ),
                            ),
                            const Spacer(),
                            _SheetIconButton(
                              icon: Icons.close_rounded,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: AppSpacing.fromLTRB(context, 20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: mergedListenable,
                            builder: (context, _) {
                              return _TaskPreviewCard(
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                dueDate: _dueDate,
                              );
                            },
                          ),
                          AppSpacing.h(context, 20),
                          const _SectionLabel(
                            title: 'Task details',
                            subtitle:
                                'Capture the work with a crisp title and context.',
                          ),
                          AppSpacing.h(context, 14),
                          _SectionCard(
                            child: Column(
                              children: [
                                TaskInputField(
                                  label: 'Title',
                                  hintText: 'Ship the dashboard polish',
                                  controller: _titleController,
                                  validator: ValidationLogic.taskTitle,
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                ),
                                AppSpacing.h(context, 16),
                                TaskInputField(
                                  label: 'Description',
                                  hintText: 'Add a clean brief or notes',
                                  controller: _descriptionController,
                                  maxLines: 4,
                                  textInputAction: TextInputAction.newline,
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.h(context, 20),
                          const _SectionLabel(
                            title: 'Schedule',
                            subtitle:
                                'Set a due date if the task needs a clear deadline.',
                          ),
                          AppSpacing.h(context, 14),
                          _SectionCard(
                            padding: AppSpacing.all(context, 16),
                            child: AppDateTimePicker(
                              label: 'Due date',
                              value: _dueDate,
                              onChanged: (value) =>
                                  setState(() => _dueDate = value),
                            ),
                          ),
                          AppSpacing.h(context, 14),

                          Row(
                            children: [
                              Expanded(
                                child: GradientButton(
                                  label: 'Cancel',
                                  variant: ButtonVariant.secondary,
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                              AppSpacing.w(context, 12),
                              Expanded(
                                child: GradientButton(
                                  label: 'Create Task',
                                  isLoading: widget.isLoading,
                                  onPressed: _submit,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}

class _AddTaskComposerRoute extends StatelessWidget {
  const _AddTaskComposerRoute({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final size = MediaQuery.sizeOf(context);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  Positioned(
                    top: -80,
                    right: -30,
                    child: Container(
                      height: 220,
                      width: 220,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 120,
                    left: -60,
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: AnimatedPadding(
              duration: AppConstants.fastAnimation,
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.value(context, size.width >= 700 ? 24 : 12),
                AppSpacing.value(context, 24),
                AppSpacing.value(context, size.width >= 700 ? 24 : 12),
                AppSpacing.value(context, 12) + viewInsets.bottom,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 760,
                    maxHeight: size.height * 0.92,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskPreviewCard extends StatelessWidget {
  const _TaskPreviewCard({
    required this.title,
    required this.description,
    required this.dueDate,
  });

  final String title;
  final String description;
  final DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title.isNotEmpty;
    final hasDescription = description.isNotEmpty;

    return AnimatedContainer(
      duration: AppConstants.fastAnimation,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.primary.withValues(alpha: 0.06),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: hasTitle
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppConstants.fastAnimation,
                  child: Text(
                    hasTitle ? title : 'Your next sharp execution task',
                    key: ValueKey(hasTitle ? title : 'placeholder'),
                    style: AppTypography.textTheme.titleLarge?.copyWith(
                      color: hasTitle
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: AppConstants.fastAnimation,
            child: Text(
              hasDescription
                  ? description
                  : 'Add supporting notes, then lock a due date if timing matters.',
              key: ValueKey(
                hasDescription ? description : 'description-placeholder',
              ),
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PreviewStatChip(
                icon: Icons.notes_rounded,
                label: hasDescription
                    ? '${description.length} chars'
                    : 'No notes yet',
              ),
              _PreviewStatChip(
                icon: Icons.event_rounded,
                label: dueDate == null
                    ? 'No deadline'
                    : DateFormat('dd MMM, hh:mm a').format(dueDate!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PreviewStatChip extends StatelessWidget {
  const _PreviewStatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SheetIconButton extends StatelessWidget {
  const _SheetIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.86),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: SizedBox(
          height: 44,
          width: 44,
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
