# Objectif du Workshop

Ce workshop vise à créer un système de gestion de contenu (CMS) complet comprenant des fonctionnalités de CRUD pour les utilisateurs, les catégories, les articles et les tags. Les participants développeront un backend avec un panneau d'administration utilisant **PHP** et **MySQLi**, tout en adoptant des pratiques de sécurité.

---

## Fonctionnalités Clés

### Gestion des utilisateurs
- Création, modification, suppression d’utilisateurs.
- Gestion des profils utilisateur (biographie, photo de profil).

### Gestion des catégories
- Ajouter, modifier et supprimer des catégories.

### Gestion des articles
- Création, publication, planification et mise à jour des articles.
- Gestion des brouillons et statistiques de vues.

### Gestion des tags
- Ajout, modification et suppression de tags.
- Liaison des tags avec des articles.

### Admin Panel
- Interface sécurisée pour gérer l’ensemble des entités.

---

## Plan du Workshop

### Étape 1 : Analyse du Cahier des Charges
- **Comprendre les besoins du projet** :
  - Gestion des utilisateurs, catégories, articles et tags.
  - Panneau d'administration ergonomique.
  - Sécurisation des données et des opérations CRUD.
- **Identifier les règles de gestion** :
  - Les articles doivent être liés à des catégories et des tags.
  - Les utilisateurs gèrent les articles selon leur rôle.
- Créer une liste des fonctionnalités prioritaires.

---

### Étape 2 : Conception de la Base de Données (ERD)
- Créer un diagramme ERD basé sur les tables suivantes :
  - `users` : Gestion des utilisateurs.
  - `categories` : Organisation des contenus.
  - `articles` : Gestion des contenus principaux.
  - `tags` et `article_tags` : Étiquetage des articles.
- **Définir les relations entre les entités** :
  - Relations un-à-plusieurs (`utilisateurs -> articles`, `catégories -> articles`).
  - Relations plusieurs-à-plusieurs (`articles <-> tags`).

---

### Étape 3 : Création des Requêtes SQL
- Écrire les requêtes SQL pour créer les tables :
  - Inclure des clés primaires, des clés étrangères et des index pour optimiser les performances.
- Tester les requêtes dans un environnement local MySQL.
- Ajouter des contraintes de suppression en cascade pour maintenir l’intégrité des données.

---

### Étape 4 : Conception UML (Use Case)
- Créer un diagramme de cas d’utilisation pour illustrer les interactions utilisateur :
  - Gestion des utilisateurs.
  - Gestion des articles.
  - Ajout de catégories et de tags.
  - Consultation des articles publiés.

---

### Étape 5 : Développement Backend (Admin Panel)
- **Environnement de développement** :
  - Installer PHP, MySQL et un serveur web local (par exemple, XAMPP).
- **Modules principaux** :
  - **Authentification utilisateur** : Connexion, inscription, réinitialisation de mot de passe.
  - **Gestion CRUD** des entités : utilisateurs, catégories, articles et tags.
- **Fonctionnalités supplémentaires** :
  - Filtrage et tri des articles.
  - Affichage des statistiques (vues d’articles, répartition par catégorie).

---

### Étape 6 : Adopter les Pratiques de Sécurité
- **Validation et échappement des entrées** :
  - Utiliser des requêtes préparées pour éviter les injections SQL.
- **Gestion des mots de passe** :
  - Hachage des mots de passe avec `password_hash` et vérification avec `password_verify`.
- **Authentification et autorisation** :
  - Implémenter des sessions sécurisées et vérifier les rôles utilisateur.
- **Protection contre les attaques XSS et CSRF** :
  - Échapper les données affichées dans le HTML.
  - Utiliser des tokens CSRF pour les formulaires.

