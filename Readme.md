# TP Cloud 2 : Infrastructure as Code avec OpenTofu et LocalStack

## 1. Objectif Pédagogique (Objectif)
L'objectif de ce TP est d'approfondir la pratique de l'Infrastructure as Code (IaC) en simulant un environnement Cloud AWS complet en local.
Nous utilisons **OpenTofu** pour l'orchestration des ressources et **LocalStack** pour émuler les services AWS (S3 et EC2) sans dépendance externe ni coût .

## 2. Structure du Rendu (Rendu attendu)
Ce dépôt contient l'ensemble des fichiers requis pour le déploiement de l'infrastructure  :
* `main.tf` : La configuration principale du provider AWS et des ressources.
* `variables.tf` : Définition des variables (région, type d'instance, nom du bucket) pour une meilleure modularité.
* `outputs.tf` : Affichage des informations clés après le déploiement (ID de l'instance, nom du bucket).
* `screenshot.png` : Preuve visuelle du fonctionnement (résultat de la commande `awslocal`).


## 3. Étapes Réalisées (Étapes)

### 3.1 Installation des outils
L'environnement a été préparé avec les outils suivants :
* **OpenTofu** : Pour la gestion de l'infrastructure.
* **LocalStack** : Exécuté via Docker pour simuler AWS.
* **Python & AWS CLI Local** : Installés pour interagir avec LocalStack (`pip install awscli-local`).
* **Docker Desktop** : Nécessaire pour faire tourner le conteneur LocalStack.

### 3.2 Configuration et lancement de LocalStack
Nous avons lancé LocalStack en mode Docker. Le service écoute sur le port **4566** et émule les services S3, EC2, Lambda, etc. 
* Commande de démarrage : `localstack start` (ou via `docker run`).
* Vérification : Le service affiche "Ready." dans le terminal.

### 3.3 Configuration AWS CLI
Pour permettre à OpenTofu et au CLI de communiquer avec notre "faux" cloud, nous avons configuré des identifiants factices via `aws configure`  :
* **Access Key / Secret Key** : `test`
* **Région** : `us-east-1`
* **Format** : `json`

### 3.4 Configuration du provider AWS pour OpenTofu
Le fichier `main.tf` a été configuré pour rediriger toutes les requêtes vers `http://localhost:4566` au lieu des serveurs réels d'AWS.

**Point technique important :**
Nous avons défini deux ressources principales  :
    AWS S3 Bucket : tp2-cloud-bucket
    AWS EC2 Instance : Type t2.micro (AMI fictive).

### 3.5 Initialisation et déploiement
Le cycle de vie de l'IaC a été validé avec succès  :
    Initialisation : tofu init pour télécharger le plugin AWS (hashicorp/aws).
    Planification : tofu plan pour prévisualiser la création des 2 ressources.
    Application : tofu apply pour créer effectivement les ressources dans LocalStack.
    Vérification : L'infrastructure a été vérifiée via la commande awslocal s3 ls, confirmant la présence du bucket créé.

### 3.6 Nettoyage (Suppression)
Pour valider la réversibilité de l'infrastructure, la commande suivante permet de tout détruire : tofu destroy