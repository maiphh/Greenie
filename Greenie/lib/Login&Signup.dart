import 'package:flutter/material.dart';
import 'Login.dart';
import 'Signup.dart';

class LS extends StatelessWidget {
  const LS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("lib/assets/Signup.png"), fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Text(
              "Welcome to Greenie",
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w900),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 150.0, vertical: 15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
            child: const Text(
              'Sign In',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 120.0, vertical: 15),
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.white, width: 1.5, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'signup');
            },
            child: const Text(
              'Create Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 150),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "By signing up, I agree to Greenie’s Terms of Service, Payments Terms of Service, Privacy Policy, Guest Refund Policy and Host Guarantee Terms.",
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12,
                  color: Colors.white70,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }
}
