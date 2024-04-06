# Controle de Tarefas

:closed_book: O aplicativo de tarefas é uma plataforma móvel desenvolvida em Flutter, projetada para auxiliar os usuários na organização e gerenciamento de suas tarefas diárias. Com funcionalidades de login seguro e registro de usuários, o aplicativo oferece uma interface intuitiva para adicionar, visualizar e acompanhar tarefas em tempo real.

## Pré-requisitos

### Clonando o Repositorio

Para obter uma cópia do código-fonte do aplicativo e executar ele, siga estas etapas simples:

1.Abra o terminal ou prompt de comando.

2.Navegue até o diretório onde você deseja clonar o repositório.

3.Execute o comando abaixo para clonar o repositório:

4.Após o término do processo de clonagem, você terá uma cópia local do repositório em seu sistema.

```git
git clone https://github.com/IagoAntunes/tasks_app.git
```
### Configurando Flutter

Certifique-se de ter o Flutter e o Dart instalados em sua máquina. Para obter instruções sobre como instalar, consulte a [documentação oficial do Flutter](https://flutter.dev/docs/get-started/install).

#### Instale as dependências
flutter pub get

#### Execute o aplicativo
flutter run

## Como Testar o Projeto Flutter

O teste do seu projeto Flutter é uma etapa crucial para garantir que tudo funcione conforme o esperado. Aqui estão algumas instruções sobre como testar o projeto:

### Testes de Unidade
```Coverage é uma métrica que indica quantas linhas de código, instruções, condições ou caminhos do programa são testados pelo conjunto de testes unitários.```

Coverage do Aplicativo: 78,5%

Coverage Login: 91,7%

Coverage ListTasks: 84,7%

Coverage AddTask: 61.1%

Os testes de unidade são usados para testar unidades individuais de código. No Flutter, os testes de unidade são escritos usando a biblioteca `flutter_test`, com auxilio de outras bibliotecas [**mocktail**](https://pub.dev/packages/mocktail), [**bloc_test**](https://pub.dev/packages/bloc_test)

Para executar os testes de unidade, siga estas etapas:

```dart
flutter test
```
### Ferramentas utilizadas

- Aplicativo: Flutter
- BackEnd/Banco: Firebase/Firestore
- Autenticação: Firebase Authentication
- CI: Github Actions/[CodeMagic](https://codemagic.io/start/)
- [**firebase_core**](https://pub.dev/packages/firebase_core)
- [**firebase_auth**](https://pub.dev/packages/firebase_auth)
- [**firebase_storage**](https://pub.dev/packages/firebase_storage)
- [**cloud_firestore**](https://pub.dev/packages/cloud_firestore)
- [**bloc**](https://pub.dev/packages/bloc)
- [**flutter_bloc**](https://pub.dev/packages/flutter_bloc)
- [**SharedPreferences**](https://pub.dev/packages/shared_preferences)
- [**sqflite**](https://pub.dev/packages/sqflite)
- [**intl**](https://pub.dev/packages/intl)
- [**image_pickert**](https://pub.dev/packages/image_picker)
- [**uuid**](https://pub.dev/packages/uuid)
- [**carousel_slider**](https://pub.dev/packages/carousel_slider)
- [**connectivity_plus**](https://pub.dev/packages/connectivity_plus)
- [**bloc_test**](https://pub.dev/packages/bloc_test)
- [**mocktail**](https://pub.dev/packages/mocktail)

### Arquitetura do Aplicativo
[<img align="left" alt="Warpnet" src="https://github.com/IagoAntunes/tasks_app/blob/main/assets/github/architecture_flow_app.png"/>](Arquitetura)

### Arquitetura do Banco(Firestore)
[<img align="left" alt="Warpnet" src="https://github.com/IagoAntunes/tasks_app/blob/main/assets/github/database_tables_firestore_app.png"/>](ArquiteturaDatabase)
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\

### Telas do App

[<img  height="800px" width="380px" alt="Warpnet"  src="https://github.com/IagoAntunes/tasks_app/blob/main/assets/github/app_login_page.png"/>](TelaLogin)
[<img  height="800px" width="380px" alt="Warpnet"  src="https://github.com/IagoAntunes/tasks_app/blob/main/assets/github/app_tasksList_page.png"/>](TelaLogin)
[<img  height="800px" width="380px" alt="Warpnet"  src="https://github.com/IagoAntunes/tasks_app/blob/main/assets/github/app_add_page.png"/>](TelaListaTarefas)
