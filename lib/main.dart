import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

const String baseUrl = "http://compressor.theapplicationdevelopers.in";

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Navigating to the WebView page immediately after the splash screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 280.0 +
                  (MediaQuery.of(context).size.width * _animation.value),
              height: 250.0 +
                  (MediaQuery.of(context).size.width * _animation.value),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/spukar-logo.png',
                  width: 230.0,
                  height: 230.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              WebView(
                initialUrl: "$baseUrl/frontend/login",
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onPageStarted: (url) {
                  setState(() {
                    if (url == "$baseUrl/user/dashboard" ||
                        url == "$baseUrl/frontend/login") {
                      _isLoading = true;
                    } else {
                      _isLoading = false;
                    }
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    _isLoading = false;
                  });
                },
                navigationDelegate: (NavigationRequest request) {
                  return NavigationDecision.navigate;
                },
              ),
              if (_isLoading)
                Center(
                  child: Image.asset(
                    'assets/spukar.jpg',
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
