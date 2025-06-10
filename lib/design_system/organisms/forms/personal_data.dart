// import 'package:flutter/cupertino.dart';
// import 'package:ser_manos/design_system/molecules/inputs/form_builder.dart';

// import '../../molecules/inputs/inputs.dart';
// import '../../tokens/colors.dart';
// import '../../tokens/typography.dart';
// import '../cards/input_card.dart';
// import '../cards/upload_profile_picture.dart';

// class PersonalData extends StatelessWidget {
//   final TextEditingController birthDateController;
//   final String? selectedGender;
//   final ValueChanged<String?> onGenderChanged;
//   final String? birthDateError;

//   const PersonalData({
//     super.key,
//     required this.birthDateController,
//     required this.selectedGender,
//     required this.onGenderChanged,
//     required this.birthDateError,
//   });

//     bool _isValidBirthDate(String? input) {
//     if (input == null) return false;
//     final regex = RegExp(r'^(\d{2})/(\d{2})/(\d{4})\$');
//     final match = regex.firstMatch(input);
//     if (match == null) return false;

//     final day = int.tryParse(match.group(1)!);
//     final month = int.tryParse(match.group(2)!);
//     final year = int.tryParse(match.group(3)!);

//     try {
//       final date = DateTime(year!, month!, day!);
//       return date.day == day && date.month == month && date.year == year;
//     } catch (_) {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Datos de perfil',
//           style: AppTypography.headline1.copyWith(color: AppColors.neutral100),
//         ),
//         const SizedBox(height: 24),

//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderAppInput(
//               name: 'birthDate',
//               label: 'Fecha de nacimiento',
//               placeholder: 'DD/MM/YYYY',
//               validator: (value) {
//                 if (value == null || !_isValidBirthDate(value)) {
//                   return 'Fecha inválida';
//                 }
//                 return null;
//               },
//             ),
//             if (birthDateError != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Text(
//                   birthDateError!,
//                   style: AppTypography.caption.copyWith(color: AppColors.error100),
//                 ),
//               ),
//           ],
//         ),
//         // AppInput(
//         //   label: 'Fecha de nacimiento',
//         //   placeholder: 'DD/MM/YYYY',
//         //   controller: birthDateController,
//         // ),
//         const SizedBox(height: 24),

//         InputCard(
//           selectedGender: selectedGender,
//           onGenderChanged: onGenderChanged,
//         ),
//         const SizedBox(height: 24),

//         UploadProfilePicture(
//           onUploadPressed: () {
//             print('Pressed upload profile picture');
//           },
//         ),
//       ],
//     );
//   }
// }
