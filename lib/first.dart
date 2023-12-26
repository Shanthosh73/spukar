// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final prefs = await SharedPreferences.getInstance();
//   final username = prefs.getString('username');
//   final password = prefs.getString('password');
//
//   runApp(MyApp(
//     username: username,
//     password: password,
//   ));
// }
//
// class MyApp extends StatelessWidget {
//   final String? username;
//   final String? password;
//
//   MyApp({required this.username, required this.password});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/home': (context) => MyHomePage(
//               username: username,
//               password: password,
//             ),
//       },
//       initialRoute: '/',
//     );
//   }
// }
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     );
//
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           Future.delayed(Duration(milliseconds: 500), () {
//             Navigator.pushReplacementNamed(context, '/home');
//           });
//         }
//       });
//
//     _controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return Container(
//               width: 280.0 +
//                   (MediaQuery.of(context).size.width * _animation.value),
//               height: 250.0 +
//                   (MediaQuery.of(context).size.width * _animation.value),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Image.asset(
//                   'assets/spukar-logo.png',
//                   width: 230.0,
//                   height: 230.0,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   final String? username;
//   final String? password;
//
//   MyHomePage({required this.username, required this.password});
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final _controller = Completer<WebViewController>();
//   bool _isLoading = true;
//
//   String? username;
//   String? password;
//
//   @override
//   void initState() {
//     super.initState();
//
//     username = widget.username;
//     password = widget.password;
//
//     _loadWebView();
//   }
//
//   void _loadWebView() async {
//     WebView.platform = SurfaceAndroidWebView();
//
//     // Load WebView data into WebView
//     _controller.future.then((controller) async {
//       String persistedData = await _getPersistedData();
//       controller.evaluateJavascript(
//           'document.documentElement.innerHTML = "$persistedData";');
//       controller.loadUrl(
//           "http://compressor.theapplicationdevelopers.in/frontend/login");
//     });
//   }
//
//   Future<String> _getPersistedData() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('webview_data') ?? '';
//   }
//
//   void _persistData(String data) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('webview_data', data);
//   }
//
//   void loginSuccess() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('username', username!);
//     prefs.setString('password',
//         'yourFixedPassword'); // Replace 'yourFixedPassword' with the actual password logic
//   }
//
//   @override
//   void dispose() {
//     // Persist WebView data before disposing
//     _controller.future.then((controller) async {
//       String data = await controller
//           .evaluateJavascript('document.documentElement.outerHTML');
//       _persistData(data);
//     });
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (await _controller.future
//             .then((controller) => controller.canGoBack())) {
//           _controller.future.then((controller) => controller.goBack());
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: SafeArea(
//         child: Scaffold(
//           body: SizedBox(
//             width: double.infinity,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 WebView(
//                   initialUrl:
//                       "http://compressor.theapplicationdevelopers.in/frontend/login",
//                   onWebViewCreated: (WebViewController controller) {
//                     _controller.complete(controller);
//                   },
//                   onPageFinished: (url) {
//                     setState(() {
//                       _isLoading = false;
//                     });
//                   },
//                   onPageStarted: (url) {
//                     setState(() {
//                       _isLoading = true;
//                     });
//                   },
//                   navigationDelegate: (NavigationRequest request) {
//                     if (request.url.contains('/login-success')) {
//                       loginSuccess();
//                     }
//                     return NavigationDecision.navigate;
//                   },
//                 ),
//                 if (_isLoading)
//                   Image.asset(
//                     'assets/spukar.jpg',
//                     width: 50.0,
//                     height: 50.0,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
