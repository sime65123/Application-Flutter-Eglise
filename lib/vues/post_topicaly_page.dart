import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/modeles/topicality_model.dart';
import 'package:groupe_des_vainqueurs/vues/topicaly_image.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class PostContainer extends StatefulWidget {
  final Topicality topicality;

  const PostContainer({super.key, required this.topicality});
  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PostHeader(topicality: widget.topicality),
                const SizedBox(
                  height: 4.0,
                ),
                Text((widget.topicality.titre)
                    .toString()), //-------------------------------------------------
              ],
            ),
          ),
          TopicalyImage(url: widget.topicality.topicalityUrlImg),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   child: _PostButton3(topicality: widget.topicality),
          // ),
        ],
      ),
    );
  }
}

class _PostButton3 extends StatefulWidget {
  final Topicality topicality;

  const _PostButton3({required this.topicality});

  @override
  State<_PostButton3> createState() => __PostButton3State();
}

class __PostButton3State extends State<_PostButton3> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FutureBuilder<bool>(
              // Appeler la méthode checkIfLiked dans le paramètre future
              future: Topicality().checkIfLiked(
                (widget.topicality.idTopicality).toString(),
                Provider.of<User>(context, listen: false)
                    .displayName
                    .toString(),
              ),
              // Construire le widget en fonction de l'état du futur
              builder: (context, snapshot) {
                // Si le futur n'a pas encore de données, afficher un indicateur de chargement
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                // Si le futur a des données, récupérer la valeur booléenne
                bool liked = snapshot.data!;
                // Retourner le widget IconButton avec la couleur et l'action appropriées
                return IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    // Si liked est vrai, mettre la couleur rouge, sinon gris
                    color: liked ? Colors.orange[900] : Colors.grey,
                  ),
                  onPressed: () {
                    // Si liked est vrai, appeler la méthode dislike, sinon like
                    liked
                        ? Topicality().dislikeTopicality(
                            (widget.topicality.idTopicality).toString(),
                            Provider.of<User>(context, listen: false)
                                .displayName
                                .toString(),
                          )
                        : Topicality().likeTopicality(
                            (widget.topicality.idTopicality).toString(),
                            Provider.of<User>(context, listen: false)
                                .displayName
                                .toString(),
                          );
                    // Mettre à jour l'état du widget pour changer la couleur du bouton
                    setState(() {
                      // Inverser la valeur de liked
                      liked = !liked;
                    });
                  },
                );
              },
            ),
            Text(widget.topicality.likes.toString()),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.3,
          child: _PostButton(
            topicality: widget.topicality,
            icon: Icon(
              MdiIcons.shareOutline,
              color: Colors.grey[600],
              size: 20.0,
            ),
            label: 'share'.tr,
            onTap: () => print('partager'),
          ),
        ),
      ],
    );
  }
}

//-----------------------------------------------------------------------------------------------
class _PostStats extends StatelessWidget {
  final Topicality topicality;

  const _PostStats({required this.topicality});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            _PostButton2(
              topicality: topicality,
              icon: Icon(
                MdiIcons.thumbUpOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'like'.tr,
              onTap: () {},
            ),
            _PostButton(
              topicality: topicality,
              icon: Icon(
                MdiIcons.shareOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'share'.tr,
              onTap: () => print('partager'),
            ),
          ],
        ),
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Topicality topicality;
  final void Function() onTap;

  const _PostButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.topicality});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(
                  width: 4.0,
                ),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostButton2 extends StatelessWidget {
  final Icon icon;
  final String label;
  final Topicality topicality;
  final void Function() onTap;

  const _PostButton2(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.topicality});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text((topicality.likes).toString()),
                const SizedBox(
                  width: 4.0,
                ),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Topicality topicality;

  const _PostHeader({required this.topicality});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: primaryColor,
          radius: 15.0,
          child: Icon(
            Icons.newspaper,
            color: Colors.orange[900],
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Column(
          children: [
            Text('Auteur\t' +
                (topicality.userNameAuthor)
                    .toString()), //--------------------------------

            const Text(""),
          ],
        )
      ],
    );
  }
}
