import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/modeles/testimony_model.dart';
import 'package:groupe_des_vainqueurs/modeles/topicality_model.dart';
import 'package:groupe_des_vainqueurs/vues/topicaly_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PostContainer2 extends StatelessWidget {
  final TestimonyModel testimonyModel;

  const PostContainer2({super.key, required this.testimonyModel});

  void launchURLVideo(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          await launch((testimonyModel.urlYoutube).toString());
          // TODO: implémenter la redirection vers la vidéo YouTube
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              (testimonyModel.titre).toString(),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'images/im.jfif',
              height: 100.0,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
