# Application de gestion de notes (Flutter + SQLite)

Ce projet répond au cahier des charges *Niveau Intermédiaire — Semaine 6* :
- Écran de **connexion** sécurisé (mock) avec messages d’erreur clairs
- **Liste des notes** (CRUD complet) avec SQLite (sqflite)
- **Ajout / Édition / Suppression** de notes
- **Navigation** claire + design simple et lisible
- Messages d’erreur et gestion d’exceptions de base
- Persistance de session (Shared Preferences)

## Démarrage rapide

1. **Pré-requis**: Flutter 3.22+
2. **Décompresser** le ZIP.
3. Ouvrir un terminal dans le dossier du projet, puis exécuter :
   ```bash
   flutter create .        # génère les dossiers de plateforme (android/ios/web)
   flutter pub get
   flutter run             # choisir un device ou un émulateur
   ```

> Si vous avez déjà un projet Flutter existant, vous pouvez simplement **copier/remplacer** le dossier `lib/` et le fichier `pubspec.yaml`, puis faire `flutter pub get`.

## Identifiants par défaut (mock)
- **Utilisateur** : `admin`
- **Mot de passe** : `admin123`

> Ces identifiants sont gérés **localement** (sans backend), pensés pour la démo. À remplacer par une vraie authentification si besoin.

## Structure
```
lib/
  main.dart
  theme/app_theme.dart
  utils/validators.dart
  data/
    app_database.dart
    note.dart
    note_dao.dart
    auth_service.dart
  screens/
    login_screen.dart
    notes_list_screen.dart
    edit_note_screen.dart
  widgets/
    note_card.dart
pubspec.yaml
wireframes/ (wireframes textuels)
assets/ (réservé aux icônes/images si besoin)
```

## Notes techniques
- Base locale via **sqflite** avec table `notes` :
  - `id` (INTEGER, PK, AUTOINCREMENT)
  - `title` (TEXT), `content` (TEXT), `createdAt` (INTEGER/epoch), `updatedAt` (INTEGER/epoch)
- Séparation **DAO** / **Model** / **UI**
- **Try/catch** aux points critiques (DB, IO) + messages d’erreur utilisateur
- **SharedPreferences** pour mémoriser la session (simple flag booléen + username)

## Wireframes (texte)
Voir `wireframes/WIREFRAMES.md`.
