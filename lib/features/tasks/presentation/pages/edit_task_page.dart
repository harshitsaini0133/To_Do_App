import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/utils/form_utils.dart';
import 'package:to_do_app/core/widgets/app_button.dart';
import 'package:to_do_app/core/widgets/app_date_time_picker.dart';
import 'package:to_do_app/core/widgets/app_error_snackbar.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';
import 'package:to_do_app/core/widgets/custom_app_bar.dart';
import 'package:to_do_app/core/widgets/task_input_field.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';
import 'package:to_do_app/features/tasks/presentation/bloc/task_bloc.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key, required this.task});

  final Task task;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    HapticFeedback.lightImpact();
    FormUtils.unfocus(context);
    context.read<TaskBloc>().add(
      TaskUpdated(
        widget.task.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dueDate: _dueDate,
          clearDescription: _descriptionController.text.trim().isEmpty,
          clearDueDate: _dueDate == null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting != current.isSubmitting ||
          previous.errorMessage != current.errorMessage ||
          previous.actionMessage != current.actionMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          showErrorSnackBar(context, state.errorMessage!);
          context.read<TaskBloc>().add(const TaskFeedbackCleared());
        } else if (!state.isSubmitting &&
            state.actionMessage == 'Task updated') {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Edit Task'),
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.pageGradient),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: AppSpacing.pagePadding(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refine the details and keep the momentum tight.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    AppSpacing.h(context, 24),
                    TaskInputField(
                      label: 'Title',
                      hintText: 'Task title',
                      controller: _titleController,
                      validator: ValidationLogic.taskTitle,
                    ),
                    AppSpacing.h(context, 18),
                    TaskInputField(
                      label: 'Description',
                      hintText: 'Notes, context, links',
                      controller: _descriptionController,
                      maxLines: 5,
                    ),
                    AppSpacing.h(context, 18),
                    AppDateTimePicker(
                      label: 'Due date',
                      value: _dueDate,
                      onChanged: (value) => setState(() => _dueDate = value),
                    ),
                    AppSpacing.h(context, 28),
                    Builder(
                      builder: (context) {
                        final state = context.watch<TaskBloc>().state;
                        return GradientButton(
                          label: 'Save Changes',
                          isLoading: state.isSubmitting,
                          onPressed: _save,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
