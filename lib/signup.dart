import 'package:flutter/material.dart';
import 'package:task_manager/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  runApp(SignupApp());
}

class SignupApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Registro(),
    );
  }
}

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                right: 20.0,
                top: -30.0,
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.colorEE7272.withOpacity(0.5),
                  ),
                ),
              ),
              Positioned(
                right: -20.0,
                top: -10.0,
                child: Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.8),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Regístrate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su nombre completo';
                            }
                            return null;
                          },
                          onSaved: (value) => _nombre = value.toString(),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su correo electrónico';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value.toString(),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(Icons.password),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value.toString(),
                          obscureText: true,
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(Icons.password),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirme su contraseña';
                            }
                            /*   if (value != _password) {

                          return 'L as contraseñas no coinciden';
                        }*/
                            return null;
                          },
                          onSaved: (value) =>
                              _confirmPassword = value.toString(),
                          obscureText: true,
                        ),
                        SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              print('Email: ${_email}');
                              print('Contraseña: ${_password}');
                              Map<String, dynamic> userData = {
                                'nombre': _nombre,
                                'email': _email,
                              };
                              ref.child('users').push().set(userData);

                              signUpWithEmailAndPassword(_email, _password);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Registro completado')));
                            }
                          },
                          child: Text(
                            'Registrar',
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
                        SizedBox(height: 8.0),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Ya tienes una cuenta? ',
                                style: TextStyle(
                                  fontSize: 16,
                                  // Cambia el tamaño de la fuente si es necesario
                                  color: Colors
                                      .colorEE7272, // Cambia el color del texto si es necesario
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Inicia sesión',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Función para registrar un usuario
Future<void> signUpWithEmailAndPassword(String email, String password) async {
  final storage = FlutterSecureStorage();

  await storage.write(key: 'pass', value: password);

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Si el registro es exitoso, userCredential contiene la información del usuario registrado
    User? user = userCredential.user;

    // Aquí puedes realizar acciones adicionales después de registrar al usuario, si es necesario
    print('Usuario registrado con el ID: ${user?.uid}');
  } catch (e) {
    // Manejo de errores durante el registro
    print('Error al registrar usuario: $e');
    // Puedes mostrar un mensaje al usuario indicando que hubo un error durante el registro
  }
}
