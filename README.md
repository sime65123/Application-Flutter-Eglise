# Groupe Des Vainqueurs - Application Mobile

Une application mobile pour l'église messianique "Groupe Des Vainqueurs" permettant aux fidèles de découvrir et partager des moments de prière, d'écouter des podcasts et de faire des dons.

## Table des matières

- [Aperçu](#aperçu)
- [Fonctionnalités](#fonctionnalités)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Utilisation](#utilisation)
- [Structure du projet](#structure-du-projet)
- [Technologies utilisées](#technologies-utilisées)

## Aperçu

Cette application mobile vise à enrichir la vie spirituelle des utilisateurs, à les aider à grandir dans la foi, et à les connecter avec d'autres chrétiens. Elle offre un accès à des contenus spirituels, des podcasts, et permet de faire des dons à l'église.

## Fonctionnalités

- **Authentification** :
  - Connexion avec Google
  - Gestion des profils utilisateurs

- **Contenu spirituel** :
  - Thèmes de prière
  - Témoignages
  - Actualités

- **Podcasts et audio** :
  - Écoute d'émissions
  - Téléchargement de fichiers audio

- **Dons** :
  - Système de dons via mobile money (USSD)

- **Multilingue** :
  - Support du français et de l'anglais
  - Détection automatique de la langue de l'appareil

## Prérequis

- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK (version 2.17.0 ou supérieure)
- Android Studio ou Visual Studio Code avec les extensions Flutter et Dart
- Un compte Firebase
- Git

## Installation

1. **Cloner le dépôt**
   ```
   git clone https://github.com/sime65123/Application-Flutter-Eglise.git
   cd groupe_des_vainqueurs
   ```

2. **Installer les dépendances**
   ```
   flutter pub get
   ```

3. **Configurer Firebase**
   - Créer un projet dans la console Firebase
   - Ajouter une application Android et/ou iOS
   - Télécharger et placer les fichiers de configuration (google-services.json pour Android, GoogleService-Info.plist pour iOS)
   - Activer l'authentification Google dans la console Firebase

4. **Vérifier la configuration**
   ```
   flutter doctor
   ```

## Configuration

1. **Configuration de Firebase**
   - Assurez-vous que les fichiers de configuration Firebase sont correctement placés :
     - Pour Android : `android/app/google-services.json`
     - Pour iOS : `ios/Runner/GoogleService-Info.plist`

2. **Configuration des plateformes**
   - Pour Android :
     ```
     flutter build apk
     ```
   - Pour iOS :
     ```
     flutter build ios
     ```

3. **Variables d'environnement (optionnel)**
   - Créer un fichier `.env` à la racine du projet pour stocker des variables sensibles

## Utilisation

1. **Lancer l'application en mode développement**
   ```
   flutter run
   ```

2. **Connexion**
   - Utilisez le bouton "Connectez-vous avec Google" sur la page de connexion
   - Autorisez l'accès à votre compte Google

3. **Navigation**
   - Utilisez la barre de navigation en bas pour accéder aux différentes sections :
     - Accueil : Contenu principal et actualités
     - Émissions : Podcasts et contenus audio
     - Téléchargements : Fichiers audio téléchargés

4. **Menu latéral**
   - Accédez aux paramètres, à l'aide, aux informations sur l'application
   - Faites un don à l'église
   - Déconnectez-vous

5. **Faire un don**
   - Accédez à la page de don depuis le menu latéral
   - Entrez le montant souhaité
   - Appuyez sur le bouton pour ouvrir l'application téléphone avec le code USSD prérempli

## Structure du projet

```
groupe_des_vainqueurs/
├── lib/
│   ├── main.dart                  # Point d'entrée de l'application
│   ├── Constant_Tools/            # Constantes (couleurs, etc.)
│   ├── controlleurs/              # Logique métier et contrôleurs
│   │   ├── repository/            # Services d'authentification
│   │   └── traduction.dart        # Gestion des traductions
│   └── vues/                      # Interfaces utilisateur
│       ├── home_page.dart         # Page d'accueil
│       ├── login_page.dart        # Page de connexion
│       ├── don_page.dart          # Page de don
│       ├── podcast_page.dart      # Page des podcasts
│       └── ...                    # Autres pages
├── android/                       # Configuration Android
├── ios/                           # Configuration iOS
├── assets/                        # Ressources (images, etc.)
├── pubspec.yaml                   # Dépendances et configuration
└── README.md                      # Documentation
```

## Technologies utilisées

- **Framework** : Flutter
- **Langage** : Dart
- **Backend** : Firebase
  - Authentication
  - Firestore (base de données)
  - Storage (stockage de fichiers)
- **Gestion d'état** : GetX
- **Autres packages** :
  - provider : Pour la gestion d'état
  - url_launcher : Pour lancer des URL externes
  - firebase_auth : Pour l'authentification
  - firebase_core : Pour l'initialisation de Firebase
