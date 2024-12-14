
# DeleteInactifsFiles

## Description

**DeleteInactifsFiles** est un script PowerShell conçu pour automatiser le nettoyage des fichiers inactifs dans un dossier spécifié, par défaut le dossier de téléchargements de l'utilisateur. Il supprime les fichiers qui n'ont pas été modifiés depuis un nombre de jours défini, aidant ainsi à maintenir l'organisation et à libérer de l'espace disque.

## Fonctionnalités

- **Suppression Automatique** : Supprime les fichiers inactifs après un nombre de jours défini.
- **Journalisation** : Enregistre les actions effectuées et les éventuelles erreurs dans un fichier de log.
- **Paramétrage Flexible** : Permet de configurer le dossier cible et le nombre de jours d'inactivité via des paramètres.
- **Exécution Automatique** : Peut être configuré pour s'exécuter automatiquement à chaque démarrage du PC.

## Prérequis

- **Système d'exploitation** : Windows 7 ou supérieur.
- **PowerShell** : Version 5.0 ou supérieure.

## Installation

1. **Cloner le Dépôt**

   ```bash
   git clone https://github.com/votre-utilisateur/DeleteInactifsFiles.git
   ```

2. **Naviguer vers le Répertoire**

   ```bash
   cd DeleteInactifsFiles
   ```

3. **(Optionnel) Personnaliser le Script**

   Vous pouvez modifier les valeurs par défaut des paramètres directement dans le script ou les spécifier lors de l'exécution.

## Utilisation

### Exécution Manuelle

1. **Ouvrir PowerShell en tant qu'Administrateur**

   - Recherchez "PowerShell" dans le menu Démarrer.
   - Cliquez droit et sélectionnez "Exécuter en tant qu'administrateur".

2. **Naviguer vers le Répertoire du Script**

   ```powershell
   cd C:\Chemin\Vers\DeleteInactifsFiles
   ```

3. **Exécuter le Script**

   - Avec les paramètres par défaut :

     ```powershell
     .\DeleteInactifsFiles.ps1
     ```

   - En spécifiant le dossier et le nombre de jours d'inactivité :

     ```powershell
     .\DeleteInactifsFiles.ps1 -FolderPath "C:\Chemin\Vers\Dossier" -DaysInactive 10
     ```

## Exécution Automatique au Démarrage

Pour automatiser l'exécution du script à chaque démarrage de votre PC, vous pouvez utiliser l'une des deux méthodes suivantes :

### Méthode 1 : Utilisation du Planificateur de Tâches Windows

1. **Ouvrir le Planificateur de Tâches**

   - Appuyez sur `Win + R`, tapez `taskschd.msc` et appuyez sur `Entrée`.

2. **Créer une Nouvelle Tâche**

   - Dans le volet de droite, cliquez sur **Créer une tâche**.

3. **Onglet Général**

   - **Nom** : `Nettoyage Téléchargements`
   - **Description** : `Exécute le script de nettoyage des téléchargements à chaque démarrage.`
   - **Options** :
     - Cochez **Exécuter avec les privilèges les plus élevés**.
     - Sélectionnez **Windows 10** ou votre version de Windows dans **Configurer pour**.

4. **Onglet Déclencheurs**

   - Cliquez sur **Nouveau…**
   - **Début de la tâche** : `À l’ouverture de session`
   - **Configurer pour** : `Tous les utilisateurs` ou un utilisateur spécifique.
   - Cliquez sur **OK**.

5. **Onglet Actions**

   - Cliquez sur **Nouveau…**
   - **Action** : `Démarrer un programme`
   - **Programme/script** : `powershell.exe`
   - **Ajouter des arguments (facultatif)** :

     ```plaintext
     -ExecutionPolicy Bypass -File "C:\Chemin\Vers\DeleteInactifsFiles.ps1" -FolderPath "C:\Users\VotreNom\Downloads" -DaysInactive 7
     ```

     Remplacez `C:\Chemin\Vers\DeleteInactifsFiles.ps1` par le chemin réel de votre script.

   - Cliquez sur **OK**.

6. **Onglet Conditions** et **Paramètres**

   - Ajustez les paramètres selon vos préférences (par exemple, ne pas exécuter si le PC fonctionne sur batterie).

7. **Enregistrer la Tâche**

   - Cliquez sur **OK**. Vous pourriez être invité à entrer vos identifiants administratifs.

### Méthode 2 : Ajout au Dossier de Démarrage

1. **Créer un Fichier de Script de Lancement**

   Créez un fichier `.ps1` qui exécute le script PowerShell. Par exemple, créez un fichier `LancerNettoyage.ps1` avec le contenu suivant :

   ```batch
   @echo off
   PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Chemin\Vers\DeleteInactifsFiles.ps1" -FolderPath "C:\Users\VotreNom\Downloads" -DaysInactive 7
   ```

2. **Placer le Fichier dans le Dossier de Démarrage**

   - Appuyez sur `Win + R`, tapez `shell:startup` et appuyez sur `Entrée`.
   - Copiez le fichier `LancerNettoyage.bat` dans ce dossier.

   > **Remarque** : Les scripts PowerShell peuvent être bloqués par la politique d'exécution. Assurez-vous que la politique d'exécution est configurée pour permettre l'exécution de scripts non signés ou utilisez l'argument `-ExecutionPolicy Bypass` comme indiqué ci-dessus.

## Paramètres

Le script accepte les paramètres suivants :

- **`-FolderPath`** : Chemin du dossier à nettoyer.
  - **Type** : `string`
  - **Valeur par défaut** : `C:\Users\VotreNom\Downloads`
  
- **`-DaysInactive`** : Nombre de jours d'inactivité avant suppression.
  - **Type** : `int`
  - **Valeur par défaut** : `7`
  - **Plage valide** : `1` à `365`

### Exemple d'Exécution avec Paramètres

```powershell
.\DeleteInactifsFiles.ps1 -FolderPath "D:\MesFichiers" -DaysInactive 14
```

## Journalisation

Le script génère un fichier de log nommé `NettoyageLog.txt` dans le dossier cible spécifié. Ce fichier enregistre les actions effectuées et les erreurs éventuelles. Voici un exemple de contenu du fichier de log :

```
2024-04-27 10:15:30 [INFO] - Début du nettoyage dans le dossier : C:\Users\VotreNom\Downloads avec une limite d'inactivité de 7 jours.
2024-04-27 10:15:31 [INFO] - Nombre de fichiers à supprimer : 5
2024-04-27 10:15:32 [INFO] - Supprimé : C:\Users\VotreNom\Downloads\ancien_fichier1.txt
2024-04-27 10:15:33 [INFO] - Supprimé : C:\Users\VotreNom\Downloads\ancien_fichier2.jpg
...
2024-04-27 10:15:35 [INFO] - Nettoyage terminé.
```

**Bon nettoyage !** 🚀
```
