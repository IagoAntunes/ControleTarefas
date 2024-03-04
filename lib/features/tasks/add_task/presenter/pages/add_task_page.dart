import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarco_teste_pratico/core/database/app_database.dart';
import 'package:demarco_teste_pratico/core/theme/app_colors.dart';
import 'package:demarco_teste_pratico/features/login/data/dao/auth_dao.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/data/service/add_task_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/domain/repositories/add_task_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/presenter/bloc/add_task_bloc.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/presenter/event/add_task_event.dart';
import 'package:demarco_teste_pratico/features/tasks/add_task/presenter/states/add_task_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../core/components/custom_textfield_component.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({super.key});
  final TextEditingController taskController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final bloc = AddTaskBloc(
    authRepository: AuthRepository(
      dao: AuthDao(),
      service: AuthFirebaseService(),
    ),
    repository: AddTaskRepository(
      service: AddTaskFirebaseService(),
    ),
  );
  final _formTask = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black_200,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Adicionar Tarefa",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer(
        listener: (context, state) {
          if (state is SuccessAddTaskListener) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sucesso"),
              ),
            );
            Navigator.pop(context);
            Navigator.pop(context, state.task);
          } else if (state is LoadingAddTaskListener) {
            showDialog(
              context: context,
              builder: (context) => const Dialog(
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text("Adicionando Tarefa")
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
        listenWhen: (context, state) => state is IAddTaskListeners,
        bloc: bloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formTask,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tarefa",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  CustomTextField(
                    controller: taskController,
                    hintText: 'Responder e-mails...',
                    prefixIcon: const Icon(
                      Icons.task,
                    ),
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatorio";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Data",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  CustomTextField(
                    controller: dateController,
                    hintText: 'dd/mm/yyyy',
                    prefixIcon: const Icon(
                      Icons.date_range,
                    ),
                    readonly: true,
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatorio";
                      }
                      return null;
                    },
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1),
                      ).then((value) {
                        if (value != null) {
                          dateController.text =
                              DateFormat('dd/MM/yyyy').format(value);
                          bloc.add(AddDateTaskEvent(date: dateController.text));
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Imagem",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    child: ElevatedButton.icon(
                      label: Text(
                        bloc.isImageSelected()
                            ? "Imagem Selecionada"
                            : "Selecionar Imagem",
                      ),
                      icon: Icon(bloc.isImageSelected()
                          ? Icons.check
                          : Icons.image_outlined),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        bloc.add(
                          SelectImageEvent(
                            imagePicker: ImagePicker(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formTask.currentState!.validate()) {
            if (bloc.taskModel.image != null) {
              bloc.add(
                AddTaskEvent(
                  nameTask: taskController.text,
                  database: AppDatabase(),
                  firestore: FirebaseFirestore.instance,
                  storage: FirebaseStorage.instance,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Imagem obrigatoria"),
                ),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
