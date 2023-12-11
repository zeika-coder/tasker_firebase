import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NewTaskScreen());
}

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: NewTaskPage(),
    );
  }
}

class NewTaskPage extends StatefulWidget {
  final Map<String, dynamic>? taskData;

  const NewTaskPage({Key? key, this.taskData}) : super(key: key);

  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _assignedController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = ''; // Valor por defecto
  String _selectedAssignedTo = ''; // Valor por defecto
  String _selectedStatus = ''; // Valor por defecto
  String _selectedUUID = ''; // Valor por defecto

  List<String> _priorities = ['Baja', 'Media', 'Alta'];
  List<String> status = ['Abierto', 'En proceso', 'Completado'];

  List<String> _assignedToList = [];

  @override
  void initState() {
    super.initState();
    if (widget.taskData != null) {
      _taskController.text = widget.taskData?['titulo'] ?? '';
      _subtaskController.text = widget.taskData?['descripcion'] ?? '';
      _dateController.text = widget.taskData?['dueDate'] ?? '';
      _selectedPriority = widget.taskData?['prioridad'] ?? '';
      _selectedAssignedTo = widget.taskData?['asignacion'] ?? '';
      _selectedStatus = widget.taskData?['estado'] ?? '';
      _selectedUUID = widget.taskData?['key'] ?? '';
    }
    _getUsers();
  }

  void _getUsers() {
    DatabaseReference usersRef = ref.child('users');
    usersRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data != null && data is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values = data;
        values.forEach((key, value) {
          final usuario = value as Map<String, dynamic>;
          if (usuario['nombre'] != null) {
            setState(() {
              _assignedToList.add(usuario['nombre'].toString());
            });
          }
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _selectedDate?.toString() ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.taskData != null) {
      return Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Crear nueva tarea'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Titulo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.text_fields),

                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el titulo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha fin',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.calendar_month),

                      ),                      onTap: () => _selectDate(context),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona una fecha';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPriority = newValue!;
                        });
                      },
                      items: _priorities.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Prioridad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.priority_high),

                      ),                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedAssignedTo,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAssignedTo = newValue!;
                        });
                      },
                      items: _assignedToList.map((assignedTo) {
                        return DropdownMenuItem(
                          value: assignedTo,
                          child: Text(assignedTo),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Asignado a: ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.person),

                      ),                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                      },
                      items: status.map((assignedTo) {
                        return DropdownMenuItem(
                          value: assignedTo,
                          child: Text(assignedTo),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.schedule),

                      ),                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _subtaskController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.short_text_outlined),

                      ),                                keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa la descripción';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              DatabaseReference taskRef = FirebaseDatabase
                                  .instance
                                  .ref("tasks/${_selectedUUID}");

                              Map<String, dynamic> taskData = {
                                'titulo': _taskController.text,
                                'descripcion': _subtaskController.text,
                                'dueDate': _dateController.text,
                                'prioridad': _selectedPriority,
                                'asignacion': _selectedAssignedTo,
                                'estado': _selectedStatus,
                              };
                              taskRef.update(taskData).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Tarea actualizada correctamente"),
                                  ),
                                );

                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                });
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("No se puedo actualizar"),
                                  ),
                                );
                              });
                            }
                          },
                          child: Text(
                            'Actualizar',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.colorEE7272,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              DatabaseReference taskRef = FirebaseDatabase
                                  .instance
                                  .ref("tasks/${_selectedUUID}");
                              taskRef.remove().then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Tarea eliminada correctamente"),
                                  ),
                                );
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                });
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("No se puedo eliminar"),
                                  ),
                                );
                              });
                            }
                          },
                          child: Text(
                            'Eliminar',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.colorEE7272,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Crear nueva tarea'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Titulo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.text_fields),

                      ),                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el titulo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha fin',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.calendar_month),

                      ),                      onTap: () => _selectDate(context),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona una fecha';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPriority = newValue!;
                        });
                      },
                      items: _priorities.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Prioridad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.priority_high),

                      ),                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAssignedTo = newValue!;
                        });
                      },
                      items: _assignedToList.map((assignedTo) {
                        return DropdownMenuItem(
                          value: assignedTo,
                          child: Text(assignedTo),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Asignado a:',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.person),

                      ),                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      onChanged: (newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                      },
                      items: status.map((assignedTo) {
                        return DropdownMenuItem(
                          value: assignedTo,
                          child: Text(assignedTo),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.schedule),

                      ),                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _subtaskController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.short_text_outlined),

                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa la descripción';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> taskData = {
                            'titulo': _taskController.text,
                            'descripcion': _subtaskController.text,
                            'dueDate': _dateController.text,
                            'prioridad': _selectedPriority,
                            'asignacion': _selectedAssignedTo,
                            'estado': _selectedStatus,
                          };
                          ref.child('tasks').push().set(taskData).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Tarea agregada correctamente"),
                              ),
                            );
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            });
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No se puedo agregar"),
                              ),
                            );
                          });
                        }
                      },
                      child: Text(
                        'Agregar',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.colorEE7272,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
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
}
