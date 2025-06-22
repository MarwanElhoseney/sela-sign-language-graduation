import 'package:flutter/material.dart';

class VerifiedDialog extends StatelessWidget {
  const VerifiedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFE7ECFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Color(0xFF092E86), size: 60),
            const SizedBox(height: 10),
            Text("Verified!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF092E86))),
            const SizedBox(height: 10),
            Text(
              "Great! You have successfully verified the account",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Reset Password screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF092E86),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Reset password", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
