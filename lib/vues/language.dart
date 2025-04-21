// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:groupe_des_vainqueurs/controlleurs/traduction.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  //bool _englishChecked = false;
  String _language = '';
  // bool _frenchChecked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose'.tr),
      ),
      body: Column(
        children: [
          //

          RadioListTile(
            title: Text('English'),
            value: 'en',
            groupValue: _language,
            onChanged: (value) {
              //value != null ? Get.updateLocale(Locale(value)) : "";
              setState(() {
                value != null ? Get.updateLocale(Locale(value)) : "";
                _language = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          RadioListTile(
            title: Text('Français'),
            value: 'fr',
            groupValue: _language,
            onChanged: (value) {
              setState(() {
                value != null ? Get.updateLocale(Locale(value)) : "";
                _language = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          )
        ],
      ),
    );
  }
}
// class DonationApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       translations: LanguageTranslation(),
//       locale: Get.deviceLocale,
//       fallbackLocale: Locale("en", "US"),
//       title: 'Donation App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//     //  home: DonationPage(),
//     home: Scaffold(),
//     );
//   }
// }

// //class DonationPage extends StatefulWidget {
//   @override
//   _DonationPageState createState() => _DonationPageState();
// }

// //class _DonationPageState extends State<DonationPage> {
//   TextEditingController _accountController = TextEditingController();

//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirmation'),
//           content: Text('textConfirm'.tr),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _performDonation();
//               },
//               child: Text('Oui'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _showCancellationMessage();
//               },
//               child: Text('Non'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _performDonation() {
//     String accountNumber = _accountController.text;

//     // Vérifier si le numéro de compte est valide
//     if (accountNumber.isNotEmpty) {
//       bool withdrawalSuccessful = performWithdrawal(accountNumber);

//       if (withdrawalSuccessful) {
//         _showSuccessMessage();
//       } else {
//         _showFailureMessage();
//       }
//     } else {
//       _showFailureMessage();
//     }
//   }

//   bool performWithdrawal(String accountNumber) {
//     // Code pour effectuer le retrait sur le compte de l'utilisateur
//     // Remplacez cette partie par votre logique réelle de retrait

//     // Exemple de logique de retrait fictive :
//     if (accountNumber == _accountController.text) {
//       // Effectuer le retrait avec succès
//       return true;
//     } else {
//       // Échec du retrait
//       return false;
//     }
//   }

//   void _showSuccessMessage() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Succès'),
//           content: Text('Don effectué avec succès !'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showFailureMessage() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('echec'.tr),
//           content: Text('textEchec'.tr),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showCancellationMessage() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Annulé'),
//           content: Text('Don annulé.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _accountController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text("title".tr)),
//         actions: [
//           DropdownButton(
//               hint: Text(
//                 "langue".tr,
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//               ),
//               items: [
//                 buildDropItem("English", "en"),
//                 buildDropItem("Français", "fr")
//               ],
//               onChanged: (value) {
//                 Get.updateLocale(Locale(value));
//               })
//         ],
//       ),
//       body: Container(
//         color: Colors.orange,
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _accountController,
//               decoration: InputDecoration(
//                 labelText: "label".tr,
//               ),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 _showConfirmationDialog();
//               },
//               child: Text("donnation".tr),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   DropdownMenuItem buildDropItem(String langue, String value) {
//     return DropdownMenuItem(
//         value: value,
//         child: Text(
//           langue,
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ));
//   }
// }
