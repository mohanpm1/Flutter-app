import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String deviceId;
  final String userId;

  OtpScreen({required this.mobileNumber, required this.deviceId, required this.userId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

    void _verifyOtp() async {
  if (_formKey.currentState!.validate()) {
    try {
      final response = await ApiService.verifyOtp(
        _otpController.text,
        widget.deviceId,
        widget.userId,
      );
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verified successfully')),
        );
        // Navigate to the next screen or perform further actions
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

  void _resendOtp() async {
    try {
      final response = await ApiService.requestOtp(widget.mobileNumber, widget.deviceId);
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP resent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter the OTP sent to ${widget.mobileNumber}'),
              SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'OTP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text('Verify OTP'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _resendOtp,
                child: Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}