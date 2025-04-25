import 'package:flutter/material.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/organisms/cards/volunteer_card.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // in case the content overflows
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/logo_square.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '“El esfuerzo desinteresado para llevar alegría a los demás será el comienzo de una vida más feliz para nosotros”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColors.neutral100,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 👇 Volunteering Card inserted here
                  VolunteeringCard(
                    imagePath: 'assets/images/volunteering.jpg', 
                    category: 'Educación',
                    title: 'Clases',
                    vacancies: 4,
                    onFavoritePressed: () {
                      print('Favorite pressed');
                    },
                    onLocationPressed: () {
                      print('Location pressed');
                    },
                  ),
                  const SizedBox(height: 40),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary100,
                        foregroundColor: AppColors.neutral0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Iniciar Sesión'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary100,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Registrarse'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}