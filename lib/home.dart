import 'package:flutter/material.dart';
import 'new_task.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MisTareasPage(),
    ActividadPage(),
    CompletadoPage(),
    ConfiguracionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: Colors.colorABABAB,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Actividad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}

class MisTareasPage extends StatefulWidget {
  @override
  _MisTareasPageState createState() => _MisTareasPageState();
}

class _MisTareasPageState extends State<MisTareasPage>
    with TickerProviderStateMixin {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  int _completedTasks = 0;
  int _inProgressTasks = 0;
  int _openTasks = 0;
  int _myTasks = 0;

  //List<Map<String, dynamic>> openAndInProgressTasks = [];
  List<Map<dynamic, dynamic>> openAndInProgressTasks = [];

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    super.initState();
    _countTasksByStatus();
    _tasksOpenAndProgress();
  }

  void _countTasksByStatus() {
    DatabaseReference tasksRef = ref.child('tasks');
    print("tareas");
    print(tasksRef);
    tasksRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(data);
      if (data != null && data is Map<dynamic, dynamic>) {
        int countInProgress = 0;
        int countOpen = 0;
        int countCompleted = 0;
        int countMyTask = 0;

        data.forEach((key, value) {
          final task = value as Map<dynamic, dynamic>;
          final status = task['estado'];
          if (status == "En proceso") {
            countInProgress++;
          } else if (status == "Abierto") {
            countOpen++;
          } else if (status == "Completado") {
            countCompleted++;
          }
          if (status == "En proceso" || status == "Abierto") {
            countMyTask++;
          }
        });

        // Actualizar los valores del estado de las tareas
        setState(() {
          _inProgressTasks = countInProgress;
          _openTasks = countOpen;
          _completedTasks = countCompleted;
          _myTasks = countMyTask;
        });
      }
    });
  }

  void _tasksOpenAndProgress() {
    DatabaseReference tasksRef = ref.child('tasks');
    tasksRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        List<Map<dynamic, dynamic>> filteredTasks = [];

        data.forEach((key, value) {
          final task = value as Map<dynamic, dynamic>;
          final status = task['estado'];

          // Filtrar tareas por estado "Abierto" o "En proceso"
          if (status == "Abierto" || status == "En proceso") {
            filteredTasks.add(task);
          }
        });

        setState(() {
          openAndInProgressTasks = filteredTasks;
        });
      }
    });
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            // Margen superior para el texto
            child: Text(
              "Tareas recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 200,
            child: _buildScrollableCard(context),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildInProgressCard(context, _myTasks, 'Mis tareas'),
                ),
                Expanded(
                  child: _buildInProgressCard(
                      context, _inProgressTasks, 'En progreso'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildInProgressCard(
                      context, _completedTasks, 'Completadas'),
                ),
                /*Expanded(
                child: _buildInProgressCard(context, 0, 'Calendario'),
              ),*/
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "Tareas recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 200,
            child: _buildScrollableCard(context),
          ),
          SizedBox(height: 8),
          // Divide cada fila en dos columnas usando Row
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildInProgressCard(context, _myTasks, 'Mis tareas'),
                ),
                Expanded(
                  child: _buildInProgressCard(
                    context,
                    _inProgressTasks,
                    'En progreso',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildInProgressCard(
                    context,
                    _completedTasks,
                    'Completadas',
                  ),
                ),
                // Aquí puedes agregar otra columna si lo necesitas
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildScrollableCard(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight / 10,
      child: Card(
        margin: EdgeInsets.all(18.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: openAndInProgressTasks.map((task) {
            return Container(
              width: 300,
              height: 50,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.colorEE7272,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  // Chip
                  Chip(
                    label: Text(
                      'Prioridad: ${task['prioridad']}',
                      style: TextStyle(color: Colors.black, fontSize: 12.0),
                    ),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(4.0),
                  ),
                  SizedBox(height: 30.0),
                  // Título
                  Text(
                    '${task['titulo']}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        fontFamily: GoogleFonts.inter().fontFamily),
                  ),
                  SizedBox(height: 15.0),

                  Text(
                    'Progreso',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.white),
                  ),
                  // Barra de progreso
                  LinearProgressIndicator(
                    value: task['status'] == 'Abierto' ? 0.0 : 0.6,
                    backgroundColor: Colors.white,
                    valueColor:
                        ColorTween(begin: Colors.black, end: Colors.black)
                            .animate(controller),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInProgressCard(BuildContext context, int count, String type) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fontSizeTitle = screenWidth * 0.01;
    double fontSizeCount = screenWidth * 0.01;

    return SizedBox(
      height: screenHeight * 0.2, // El 20% del ancho de la pantalla
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Center(
          child: ListTile(
            leading: Icon(Icons.hourglass_empty),
            title: Text(
              type,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class ActividadPage extends StatefulWidget {
  @override
  _ActividadPageState createState() => _ActividadPageState();
}

class _ActividadPageState extends State<ActividadPage> {
  List<Map<dynamic, dynamic>> recentTasks = [];

  List<Map<dynamic, dynamic>> inProgressTasks = [];

  List<Map<dynamic, dynamic>> completedTasks = [];
  final List<String> tabs = ["Recientes", "En proceso", "Completados"];

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _tasksOpenAndProgress();
  }

  void _tasksOpenAndProgress() {
    DatabaseReference tasksRef = ref.child('tasks');
    tasksRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        List<Map<dynamic, dynamic>> openTask = [];
        List<Map<dynamic, dynamic>> processTask = [];
        List<Map<dynamic, dynamic>> completedTask = [];

        data.forEach((key, value) {
          final task = value as Map<dynamic, dynamic>;
          final status = task['estado'];
          task['key'] = key;
          // Filtrar tareas por estado "Abierto" o "En proceso"
          if (status == "Abierto" || status == "En proceso") {
            openTask.add(task);
          }
          if (status == "En proceso") {
            processTask.add(task);
          }
          if (status == "Completado") {
            completedTask.add(task);
          }
        });

        setState(() {
          recentTasks = openTask;
          inProgressTasks = processTask;
          completedTasks = completedTask;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs.map((String tab) {
              return Tab(text: tab);
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(recentTasks),
            _buildTaskList(inProgressTasks),
            _buildTaskList(completedTasks),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Map<dynamic, dynamic>> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(task['titulo']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['descripcion']),
                    Text('Due Date: ${task['dueDate']}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewTaskPage(taskData: tasks[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class CompletadoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Pantalla de Completado'),
    );
  }
}

class ConfiguracionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Pantalla de Configuración'),
    );
  }
}

class TaskCard extends StatelessWidget {
  TaskCard({Key? key, required this.task, required this.progress})
      : super(key: key);
  final String task;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.check_circle),
        title: Text(task),
        subtitle: Text('Progress: $progress'),
      ),
    );
  }
}
