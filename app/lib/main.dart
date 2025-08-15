import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:susya/camera/camera_page.dart';
import 'package:susya/firebase_options.dart';
import 'package:susya/services/notifications.dart';
import 'package:susya/widgets/login_button.dart';
import '../authentication/auth_class.dart';

//bool shouldInitializeFirebase = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  _fcm.subscribeToTopic("susya");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(GetMaterialApp(
    home: LoginPage(),
  ));
}



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   bool _isLoading = false;

  Future<void> _loginWithEmail() async {
    setState(() => _isLoading = true);
    final user = await Authentication.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      context: context,
    );
    setState(() => _isLoading = false);
    if (user != null) {
      Get.to(() => CameraPage());
    }
  }

  Future<void> _registerWithEmail() async {
    setState(() => _isLoading = true);
    final user = await Authentication.registerWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      context: context,
    );
    setState(() => _isLoading = false);
    if (user != null) {
      Get.to(() => CameraPage());
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    final user = await Authentication.signInWithGoogle(context: context);
    setState(() => _isLoading = false);
    if (user != null) {
      Get.to(() => CameraPage());
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: const Color.fromARGB(255, 135, 176, 39),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Applogo.png", height: 120),
              SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _loginWithEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 135, 176, 39),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Login'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerWithEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text('Register'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _loginWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 48),
                  side: BorderSide(color: const Color.fromARGB(255, 135, 176, 39)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, color: const Color.fromARGB(255, 135, 176, 39)),
                    SizedBox(width: 8),
                    Text('Sign in with Google'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationHandler(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(flex: 2),
                  Image.asset(
                    "assets/Applogo.png",
                    height: 300,
                  ),
                  Text("PLNTdis",
                      style: TextStyle(
                          fontSize: 35,
                          color: const Color.fromARGB(255, 135, 176, 39),
                          fontWeight: FontWeight.bold)),
                  Spacer(flex: 2),
                  LoginButton(
                    title: "Login",
                    onTap: () => Get.to(() => CameraPage()),
                  ),
                  // SignInButton(),
                  Spacer(flex: 4)
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}*/
