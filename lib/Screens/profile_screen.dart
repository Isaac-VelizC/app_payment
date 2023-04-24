import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> _imageUrls = [];
  int _currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchImages() async {
    final response = await http.get(Uri.parse('https://picsum.photos/v2/list?limit=10'));
    final List<dynamic> data = jsonDecode(response.body);
    final random = Random();
    final imageUrls = data.map<String>((dynamic item) {
      final id = item['id'].toString();
      final width = 200 + random.nextInt(200);
      final height = 200 + random.nextInt(200);
      return 'https://picsum.photos/id/$id/$width/$height';
    }).toList();
    setState(() {
      _imageUrls = imageUrls;
      _startTimer();
    });
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentImageIndex++;
        if (_currentImageIndex >= _imageUrls.length) {
          _currentImageIndex = 0;
        }
      });
    });
  }

  void _showFullScreenImage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: Image.network(
              _imageUrls[_currentImageIndex],
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Center(
        child: _imageUrls.isEmpty
            ? const CircularProgressIndicator()
            : GestureDetector(
                onTap: _showFullScreenImage,
                child: Image.network(
                  _imageUrls[_currentImageIndex],
                  fit: BoxFit.cover,
                  width: ScreenUtil().setWidth(750), // Set width based on device screen width
                  height: ScreenUtil().setHeight(600), // Set height based on device screen height
                ),
              ),
      ),
    );
  }

  Future<void> _checkInternetConnection() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('No hay conexión a internet'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      _fetchImages();
    }
  }
}
