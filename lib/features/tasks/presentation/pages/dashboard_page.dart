import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/animations/app_page_route.dart';
import 'package:to_do_app/core/animations/fade_slide_up.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/widgets/app_button.dart';
import 'package:to_do_app/core/widgets/app_error_snackbar.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';
import 'package:to_do_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app/features/tasks/domain/entities/task_draft.dart';
import 'package:to_do_app/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:to_do_app/features/tasks/presentation/pages/edit_task_page.dart';
import 'package:to_do_app/features/tasks/presentation/widgets/add_task_sheet.dart';
import 'package:to_do_app/features/tasks/presentation/widgets/task_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.actionMessage != current.actionMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          showErrorSnackBar(context, state.errorMessage!);
          context.read<TaskBloc>().add(const TaskFeedbackCleared());
        } else if (state.actionMessage != null) {
          showSuccessSnackBar(context, state.actionMessage!);
          context.read<TaskBloc>().add(const TaskFeedbackCleared());
        }
      },
      builder: (context, taskState) {
        final authState = context.watch<AuthBloc>().state;
        final session = authState.session;
        final tasks = taskState.tasks;
        final completedCount = tasks.where((task) => task.completed).length;
        final remainingCount = tasks.length - completedCount;
        final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppSpacing.circular(context, 24),
              boxShadow: AppColors.softShadow,
            ),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () => _showAddTaskSheet(context),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(gradient: AppColors.pageGradient),
            child: Stack(
              children: [
                const _DashboardDecor(),
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<TaskBloc>().add(const TasksRefreshed());
                      await Future<void>.delayed(const Duration(milliseconds: 550));
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: AppSpacing.pagePadding(context),
                      children: [
                        _DashboardHeader(
                          name: session?.displayName ?? 'there',
                          onLogout: () {
                            HapticFeedback.mediumImpact();
                            context.read<AuthBloc>().add(const AuthSignOutRequested());
                          },
                        ),
                        AppSpacing.h(context, 20),
                        FadeSlideUp(
                          child: _HeroCard(
                            completedCount: completedCount,
                            remainingCount: remainingCount,
                            progress: progress,
                          ),
                        ),
                        AppSpacing.h(context, 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Task Flow',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              '${tasks.length} total',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        AppSpacing.h(context, 16),
                        if (taskState.status == TaskStatus.loading && tasks.isEmpty)
                          ...List.generate(
                            3,
                            (index) => Padding(
                              padding: AppSpacing.only(context: context, bottom: 14),
                              child: const _LoadingTaskCard(),
                            ),
                          )
                        else if (tasks.isEmpty)
                          _EmptyState(
                            onCreate: () => _showAddTaskSheet(context),
                          )
                        else
                          ...tasks.asMap().entries.map(
                                (entry) => Padding(
                                  padding: AppSpacing.only(
                                    context: context,
                                    bottom: 14,
                                  ),
                                  child: FadeSlideUp(
                                    delay: Duration(
                                      milliseconds: entry.key * 60,
                                    ),
                                    child: Dismissible(
                                      key: ValueKey(entry.value.id),
                                      direction: DismissDirection.endToStart,
                                      background: const _DeleteBackground(),
                                      onDismissed: (_) {
                                        HapticFeedback.mediumImpact();
                                        context.read<TaskBloc>().add(
                                              TaskDeleted(entry.value),
                                            );
                                      },
                                      child: TaskCard(
                                        task: entry.value,
                                        onToggle: () {
                                          HapticFeedback.selectionClick();
                                          context.read<TaskBloc>().add(
                                                TaskCompletionToggled(entry.value),
                                              );
                                        },
                                        onEdit: () {
                                          Navigator.of(context).push(
                                            AppPageRoute(
                                              page: EditTaskPage(task: entry.value),
                                            ),
                                          );
                                        },
                                        onDelete: () {
                                          HapticFeedback.mediumImpact();
                                          context.read<TaskBloc>().add(
                                                TaskDeleted(entry.value),
                                              );
                                        },
                                      ),
                                    ),
                                  ),
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
      },
    );
  }

  Future<void> _showAddTaskSheet(
    BuildContext context,
  ) {
    return showAddTaskComposer(
      context,
      onSubmit: (TaskDraft draft) {
        HapticFeedback.lightImpact();
        context.read<TaskBloc>().add(TaskCreated(draft));
      },
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.name,
    required this.onLogout,
  });

  final String name;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              AppSpacing.h(context, 6),
              Text(
                name,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.circular(context, 20),
            boxShadow: AppColors.softShadow,
          ),
          child: IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 18) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.completedCount,
    required this.remainingCount,
    required this.progress,
  });

  final int completedCount;
  final int remainingCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(context, 24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.circular(context, 32),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress snapshot',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          AppSpacing.h(context, 8),
          Text(
            'Stay deliberate. Finish the important few.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.76),
                ),
          ),
          AppSpacing.h(context, 20),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  label: 'Completed',
                  value: completedCount.toString(),
                ),
              ),
              AppSpacing.w(context, 12),
              Expanded(
                child: _StatPill(
                  label: 'Remaining',
                  value: remainingCount.toString(),
                ),
              ),
            ],
          ),
          AppSpacing.h(context, 18),
          ClipRRect(
            borderRadius: AppSpacing.circular(context, 999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(
        context: context,
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: AppSpacing.circular(context, 22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                ),
          ),
          AppSpacing.h(context, 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(context, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.circular(context, 32),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Container(
            height: AppSpacing.value(context, 96),
            width: AppSpacing.value(context, 96),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppSpacing.circular(context, 32),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              size: 42,
              color: Colors.white,
            ),
          ),
          AppSpacing.h(context, 20),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          AppSpacing.h(context, 10),
          Text(
            'Add the first task and turn this board into a clean execution list.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          AppSpacing.h(context, 20),
          GradientButton(
            label: 'Create First Task',
            expand: false,
            onPressed: onCreate,
          ),
        ],
      ),
    );
  }
}

class _LoadingTaskCard extends StatelessWidget {
  const _LoadingTaskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.value(context, 138),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.circular(context, 28),
        boxShadow: AppColors.softShadow,
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: AppSpacing.symmetric(context: context, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: AppSpacing.circular(context, 26),
      ),
      child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
    );
  }
}

class _DashboardDecor extends StatelessWidget {
  const _DashboardDecor();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -50,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -80,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
