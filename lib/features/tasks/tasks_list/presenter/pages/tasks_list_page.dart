import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demarco_teste_pratico/core/database/app_database.dart';
import 'package:demarco_teste_pratico/core/states/app_service_state.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/models/task_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:demarco_teste_pratico/core/theme/app_colors.dart';
import 'package:demarco_teste_pratico/features/login/data/dao/auth_dao.dart';
import 'package:demarco_teste_pratico/features/login/data/service/login_firebase_service.dart';
import 'package:demarco_teste_pratico/features/login/domain/repositories/auth_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/data/service/tasks_list_firebase_service.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/domain/repositories/tasks_list_repository.dart';
import 'package:demarco_teste_pratico/features/tasks/tasks_list/presenter/event/tasks_list_event.dart';

import '../../../add_task/presenter/pages/add_task_page.dart';
import '../bloc/tasks_list_bloc.dart';
import '../state/task_list_bloc_state.dart';

class TasksListPage extends StatelessWidget {
  TasksListPage({super.key});

  final bloc = TasksListBloc(
    authRepository: AuthRepository(
      dao: AuthDao(),
      service: AuthFirebaseService(),
    ),
    repository: TasksListRepository(
      service: TasksListFirebaseService(),
    ),
    connectivity: Connectivity(),
    database: AppDatabase(),
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black_200,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const HeadListTasks(),
              Expanded(
                child: Container(
                  width: double.infinity,
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
                  child: BlocProvider(
                    create: (context) => bloc,
                    child: BlocBuilder<TasksListBloc, ITaskListBlocState>(
                      bloc: bloc,
                      buildWhen: (previous, current) =>
                          current is IGetTasksListBlocState,
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
                                BlocBuilder(
                                  bloc: bloc,
                                  buildWhen: (previous, current) =>
                                      current is IChangeItemTaskListBlocState,
                                  builder: (context, state) {
                                    return CarouselTasks(
                                      listTasks: bloc.selectThreeElements(),
                                    );
                                  },
                                ),
                                BlocBuilder(
                                  bloc: bloc,
                                  buildWhen: (previous, current) =>
                                      current is ITaskItemListBlocState ||
                                      current is IChangeItemTaskListBlocState,
                                  builder: (context, state) {
                                    return Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                bloc.filterTasks.isEmpty
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 32),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.list,
                                                                size: 55,
                                                              ),
                                                              Text(
                                                                "Lista vazia",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                "Adicione uma tarefa para começar",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: ListView.builder(
                                                          itemCount: bloc
                                                              .filterTasks
                                                              .length,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              TaskItem(
                                                            task:
                                                                bloc.filterTasks[
                                                                    index],
                                                            onDismissed: (p0) {
                                                              bloc.add(
                                                                DeleteTaskListEvent(
                                                                  task: bloc
                                                                          .filterTasks[
                                                                      index],
                                                                  database:
                                                                      AppDatabase(),
                                                                  firestore:
                                                                      FirebaseFirestore
                                                                          .instance,
                                                                ),
                                                              );
                                                            },
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
                                    );
                                  },
                                ),
                              ],
                            ),
                          LoadingTasksListBlocState() => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          FailureTasksListBlocState errorState => FailureWidget(
                              errorState: errorState.failureState,
                            ),
                          _ => Container(),
                        };
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ButtonsTasksList(bloc: bloc),
    );
  }
}

class FailureWidget extends StatefulWidget {
  const FailureWidget({
    super.key,
    required this.errorState,
  });
  final FailureServiceState errorState;

  @override
  State<FailureWidget> createState() => _FailureWidgetState();
}

class _FailureWidgetState extends State<FailureWidget> {
  IconData icon = Icons.error_outline;
  String title = "Ocorreu um problema!";
  @override
  void initState() {
    super.initState();
    if (widget.errorState is NoConnectionFailureServiceState) {
      icon = Icons.signal_wifi_connected_no_internet_4_outlined;
      title = "Problema de conexão";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TasksListBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 55,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Tente novamente mais tarde",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            bloc.add(GetTasksListEvent(
              database: AppDatabase(),
              firestore: FirebaseFirestore.instance,
              storage: FirebaseStorage.instance,
              connectivity: Connectivity(),
            ));
          },
          child: const Icon(Icons.sync),
        ),
      ],
    );
  }
}

class ButtonsTasksList extends StatelessWidget {
  const ButtonsTasksList({
    super.key,
    required this.bloc,
  });

  final TasksListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: state is FailureTasksListBlocState
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskPage(),
                          ),
                        ).then((value) {
                          if (value != null) {
                            bloc.add(AddTaskListEvent(
                              task: value,
                              firestore: FirebaseFirestore.instance,
                            ));
                          }
                        });
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
                  "Adicionar",
                ),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: !bloc.isOkDone
                    ? null
                    : () {
                        bloc.add(
                          DoneTasksListEvent(
                            database: AppDatabase(),
                            firestore: FirebaseFirestore.instance,
                          ),
                        );
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
              ),
            ],
          ),
        );
      },
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
          // PopupMenuButton(
          //   iconColor: Colors.white,
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //       onTap: () async {
          //         authBloc.add(
          //           LogoutAuthBlocEvent(
          //             authOption: AuthOption.login,
          //             database: AppDatabase(),
          //           ),
          //         );
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const LoginPage(),
          //           ),
          //         );
          //       },
          //       child: const Text("Sair"),
          //     ),
          //   ],
          // ),
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
    required this.onDismissed,
  });
  final TaskModel task;
  final void Function(bool?) onChagend;
  final void Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id!),
      onDismissed: onDismissed,
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        child: const Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: CheckboxListTile(
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
        color: isDone ? AppColors.greenLight : AppColors.orangeLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isDone ? "Concluido" : "Pendente",
        style: TextStyle(
          color: isDone ? AppColors.greenDark : AppColors.orangeDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
