import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // استيراد FirebaseAuth
import '../login/login_screen.dart';
import 'change_password_screen.dart'; // استيراد شاشة تغيير كلمة المرور
import '../model/my_user.dart';
import 'edit_profile_screen.dart'; // استيراد صفحة التعديل

class ProfileScreen extends StatelessWidget {
  final MyUser? user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  // دالة تسجيل الخروج
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // تسجيل الخروج من Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // الانتقال إلى شاشة تسجيل الدخول
      );
    } catch (e) {
      // معالجة الأخطاء إذا حدثت
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/rb_44776.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text("My profile",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage("assets/images/10a2b45c5ed09b2d52fa54291eadfed7.1000x1000x1.png"),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.Name ?? "User",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // الانتقال لصفحة التعديل
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(user: user),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Other settings", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            SettingTile(icon: Icons.lock, title: "Password settings", onTap: () {
              // الانتقال إلى شاشة تغيير كلمة المرور
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(email: user?.email??""),
                ),
              );
            }),
            SettingTile(icon: Icons.chat, title: "Chat us"),
            SettingTile(
              icon: Icons.logout,
              title: "Logout",
              color: Colors.red,
              onTap: () => _signOut(context), // تنفيذ دالة الساين أوت
            ),
          ],
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback? onTap;

  const SettingTile({required this.icon, required this.title, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,  // Trigger the onTap callback when the tile is tapped
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: [
              Icon(icon, color: color ?? Colors.black),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(color: color ?? Colors.black))),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
