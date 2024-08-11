import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'otp_screen.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  Future<void> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _deviceId = androidInfo.id;
    });
  }

  void _requestOtp() async {
    if (_formKey.currentState!.validate()) {
      if (_deviceId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Device ID not available. Please try again.')),
        );
        return;
      }
      try {
        final response = await ApiService.requestOtp(_mobileController.text, _deviceId!);
        if (response['success'] == true) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                mobileNumber: _mobileController.text,
                deviceId: _deviceId!,
                userId: response['data']['userId'],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 48),
              Image.asset(
                'assets/dealsdray_logo.png',
                height: 100,
              ),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _requestOtp,
                child: Text('Request OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
