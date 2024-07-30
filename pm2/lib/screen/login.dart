import 'package:flutter/material.dart';
import 'package:pm2/services/database_service.dart';
import 'package:pm2/screen/menu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  String _errorMessage = '';

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, introduce ambos campos';
      });
      return;
    }

    bool success = await _databaseService.authenticateUser(username, password);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Menu()),
      );
    } else {
      setState(() {
        _errorMessage = 'Nombre de usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 24.0,
            bottom: 24.0 + keyboardHeight,
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://wallpapercave.com/wp/wp9748429.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        offset: Offset(0, 4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'imagenes/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                _buildTitle("Game Market"),
                SizedBox(height: 30),
                
                _buildTextField(
                  controller: _usernameController,
                  labelText: 'Nombre de usuario',
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Iniciar sesión', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 20),
                
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.5),
            shadows: [
              Shadow(
                offset: Offset(4, 4),
                color: Colors.black.withOpacity(0.5),
                blurRadius: 12,
              ),
              Shadow(
                offset: Offset(-4, -4),
                color: Colors.black.withOpacity(0.5),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                color: Colors.white,
                blurRadius: 4,
              ),
              Shadow(
                offset: Offset(-2, -2),
                color: Colors.white,
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white.withOpacity(0.75),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}