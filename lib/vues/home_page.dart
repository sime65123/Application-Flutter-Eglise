// Exemple de code qui utilise le widget Transform
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/controlleurs/repository/google_auth.dart';
import 'package:groupe_des_vainqueurs/vues/download_page.dart';
import 'package:groupe_des_vainqueurs/vues/home_page2.dart';
import 'package:groupe_des_vainqueurs/vues/login_page.dart';
import 'package:groupe_des_vainqueurs/vues/podcast_page.dart';
import 'package:provider/provider.dart';
// Importer le fichier colors.dart

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Définir l'index de l'onglet sélectionné dans le BottomNavigationBar
  int _selectedIndex = 0;

  // Définir les titres des onglets
  List<String> _tabTitles = [
    'Accueil',
    'Podcast',
    'Téléchargement',
  ];

  // Définir les icônes des onglets
  List<IconData> _tabIcons = [
    Icons.home,
    Icons.podcasts,
    Icons.download,
    // Icons.app_registration
  ];

  // Définir les widgets à afficher dans le corps de la page selon l'onglet sélectionné
  final List<Widget> _tabWidgets = [
    // Vous pouvez remplacer ces widgets par ceux que vous voulez
    HomeView(),
    AudioListScreen(),
    AudioList()
    //Center(child: Text('Page de téléchargement')),
  ];

  // Définir la fonction qui change l'index de l'onglet sélectionné
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              // Donner le logo comme image
              backgroundImage: AssetImage(
                  'images/app_logo.png'), // Remplacer par le chemin du logo dans votre dossier Images
              // Donner un rayon au CircularAvatar
              radius: 20.0,
            ),
          ),
        ],
        //leading: Icon(Icons.abc),
        // Utiliser la couleur primaire comme fond de l'AppBar
        backgroundColor: primaryColor,
        // Afficher l'icône de l'application à droite
        //leading: Icon(Icons.app_registration),
        // Afficher le nom de l'application à gauche
        title: Text(
          'Groupe Des Vainqueurs',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
      // Utiliser le widget Transform pour déplacer le drawer
      drawer: Drawer(
        child: ListView(
          // Enlever le padding par défaut
          padding: EdgeInsets.zero,
          children: [
            // Créer le header du Drawer avec le nom de l'utilisateur
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    // Donner le logo comme image
                    backgroundImage: AssetImage('images/app_logo.png'),
                    // Donner un rayon au CircularAvatar
                    radius: 50.0,
                  ),
                  Center(
                      child: Text(
                    Provider.of<User?>(context)?.displayName ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              // Utiliser la couleur secondaire comme fond du header
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
            // Créer les items du Drawer avec les menus que vous voulez
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Paramètres',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Faire quelque chose quand on clique sur cet item
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(
                'Aide',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Faire quelque chose quand on clique sur cet item
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'A propos',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('aboutpage');
                // Faire quelque chose quand on clique sur cet item
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text(
                'Faire un don',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Faire quelque chose quand on clique sur cet item
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Déconnexion',
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                AuthService().signOut();
                Navigator.of(context).pushNamed('connexion');
                // Faire quelque chose quand on clique sur cet item
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (int i = 0; i < _tabTitles.length; i++)
            BottomNavigationBarItem(
              icon: Icon(_tabIcons[i]),
              label: _tabTitles[i],
            ),
        ],
        // Utiliser la couleur d'accent comme couleur des items sélectionnés
        selectedItemColor: Colors.orange[900],
        // Utiliser la couleur d'erreur comme couleur des items non sélectionnés
        unselectedItemColor: Colors.blueGrey,
        // Définir l'index de l'item sélectionné
        currentIndex: _selectedIndex,
        // Définir la fonction qui change l'index de l'item sélectionné
        onTap: _onItemTapped,
      ),
      // Afficher le widget correspondant à l'onglet sélectionné
      //Expanded(child: _tabWidgets[_selectedIndex]),
      // ],
      // ),
      body: Column(
        children: [
          // Afficher le widget correspondant à l'onglet sélectionné
          Expanded(child: _tabWidgets[_selectedIndex]),
        ],
      ),
    );
  }
}
