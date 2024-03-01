// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:demarco_teste_pratico/core/theme/app_colors.dart';
import 'package:demarco_teste_pratico/features/login/data/dao/auth_dao.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/login/presenter/bloc/auth_bloc.dart';
import 'package:demarco_teste_pratico/features/login/presenter/event/auth_bloc_event.dart';
import 'package:demarco_teste_pratico/features/login/presenter/page/login_page.dart';
import 'package:demarco_teste_pratico/features/login/presenter/utils/auth_options_enum.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/data/service/tasks_list_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/repositories/tasks_list_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/presenter/event/tasks_list_event.dart';

import '../../../add_task/presenter/pages/add_task_page.dart';
import '../bloc/tasks_list_bloc.dart';
import '../state/task_list_bloc_state.dart';

class TasksListPage extends StatelessWidget {
  TasksListPage({super.key});

  Future<void> getData() async {
    //
  }
  final bloc = TasksListBloc(
    authRepository: AuthRepository(
      dao: AuthDao(),
      service: AuthFirebaseService(),
    ),
    repository: TasksListRepository(
      service: TasksListFirebaseService(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black_200,
      body: SafeArea(
        child: Column(
          children: [
            const HeadListTasks(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: BlocBuilder<TasksListBloc, ITaskListBlocState>(
                  bloc: bloc,
                  builder: (context, state) {
                    return switch (state) {
                      SuccessTasksListBlocState() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              enabled: !bloc.isListEmpty(),
                              decoration: const InputDecoration(
                                hintText: "Pesquise...",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                //
                              ),
                              onChanged: (value) {
                                bloc.add(FilterTaskListEvent(text: value));
                              },
                            ),
                            const SizedBox(height: 16),
                            CarouselTasks(
                              listTasks: bloc.selectThreeElements(),
                            ),
                            const Text(
                              "Tarefas",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  state is EmptyTasksListBlcoState
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 32),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.list,
                                                  size: 55,
                                                ),
                                                const Text(
                                                  "Lista vazia",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Text(
                                                  "Adicione uma tarefa para começar",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddTaskPage(),
                                                      ),
                                                    ).then((value) {
                                                      if (value != null &&
                                                          value == true) {
                                                        bloc.add(
                                                            GetTasksListEvent());
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(Icons.add),
                                                  label: const Text(
                                                    "Adicionar Tarefa",
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            itemCount:
                                                bloc.filterTasks.length + 1,
                                            itemBuilder: (context, index) =>
                                                index == bloc.filterTasks.length
                                                    ? TextButton.icon(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddTaskPage(),
                                                            ),
                                                          ).then((value) {
                                                            if (value != null &&
                                                                value == true) {
                                                              bloc.add(
                                                                  GetTasksListEvent());
                                                            }
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.add),
                                                        label: const Text(
                                                            "Adicionar Tarefa"),
                                                      )
                                                    : TaskItem(
                                                        task: bloc
                                                            .filterTasks[index],
                                                        onChagend: (p0) {
                                                          bloc.add(
                                                            SelectedTaskListEvent(
                                                              index: index,
                                                              value: p0!,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      LoadingTasksListBlocState() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      _ => Container(),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          return ElevatedButton.icon(
            onPressed: !bloc.isOkDone
                ? null
                : () {
                    bloc.add(DoneTasksListEvent());
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: const Text(
              "Concluir",
            ),
            icon: const Icon(Icons.check),
          );
        },
      ),
    );
  }
}

class HeadListTasks extends StatelessWidget {
  const HeadListTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.1,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bem Vindo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Visualize suas tarefas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.add(
                    LogoutAuthBlocEvent(
                      authOption: AuthOption.login,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text("Sair"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CarouselTasks extends StatelessWidget {
  const CarouselTasks({
    super.key,
    required this.listTasks,
  });
  final List<TaskModel> listTasks;

  @override
  Widget build(BuildContext context) {
    return listTasks.isEmpty
        ? Container()
        : Column(
            children: [
              CarouselSlider.builder(
                itemCount: listTasks.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.memory(
                              base64Decode(
                                listTasks[index].image!,
                              ),
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listTasks[index].title!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      listTasks[index].date!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  );
                  //
                },
                carouselController: CarouselController(),
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 2.0,
                  initialPage: 2,
                ),
              ),
            ],
          );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.onChagend,
    required this.task,
  });
  final TaskModel task;
  final void Function(bool?) onChagend;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      enabled: task.isDone == false,
      value: task.isDone! ? true : task.isChecked,
      onChanged: onChagend,
      title: Text(
        task.title!,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.date!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          TaskStatus(
            isDone: task.isDone!,
          ),
        ],
      ),
    );
  }
}

class TaskStatus extends StatelessWidget {
  const TaskStatus({
    super.key,
    required this.isDone,
  });
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xffEFFDE8) : const Color(0xFFFDF2E8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isDone ? "Concluido" : "Pendente",
        style: TextStyle(
          color: isDone ? const Color(0xff398711) : const Color(0xFF877311),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}