# deploiement automatique d'un serveur GLPI avev Jenkins - Terraform -  Ansible


dans ce projet nous allons automatiser presque toutes les étapes du processus d installation
ci dessous certain objectif de ce projet

- creation d'un compartiment S3 pour le stockage du fichier state du code terraform
- installation d un serveur Jenkins pour la gestion du pipeline
- a l aidre d un pipeline line Jenkins autamatisation du processus terraform pour la création des instances ECS de staging et de PROD
- generation automatique des inventaire Ansible à partir des outpout Terraform
- Execution des playbook Ansbile à l aide de JENKINS pour l installation de GLPI sur les nouvelles instances 


## Table de materière 
- [1. creation d'un compartiment S3 pour le stockage des fichier state]
    
- [2. Installation du serveur Jenkins]
    
    - [2.2 Installation de Terraform, AWS CLI, Ansible sur le serveur JENKINS](#22-install-terraform-aws-cli-ansible-inside-jenkins)
	
	

- [3. configuration initial de JENKINS ](#32-initial-setup-with-jenkins)
        - [3.1 Jenkins credentials](#321-jenkins-credentials)
        - [3.2 les plugins Jenkins à installer ](#322-jenkins-plugins)
        - [3.3 creations du pipeline jenkins ](#323-create-jenkins-multibranch-pipeline)





##1 . creation d'un compartiment S3 pour le stockage des fichier state

Connectez-vous à la AWS Management Console et ouvrez la console Amazon S3 à l'adresse https://console.aws.amazon.com/s3/


Choisissez Créer un compartiment.

L'Assistant Create bucket (Créer un compartiment) s'ouvre.

Dans Bucket name (Nom du compartiment), saisissez un nom compatible DNS pour votre compartiment.

Les nom du compartiment doit présenter les caractéristiques suivantes :

    Il doit être unique sur l'ensemble d'Amazon S3.

    Il doit comporter entre 3 et 63 caractères.

    Ne contient pas de majuscules.

    Il doit commencer par une minuscule ou un chiffre.

Une fois le compartiment créé, vous ne pouvez pas changer son nom. Pour de plus amples informations sur le choix des noms de 
compartiment, consultez la section Règles de dénomination de compartiment. 

## 2. Installation du serveur Jenkins

ici nous allons installer sur un  serveur local UBUNTU Jenkins qui vas gerer l'execution du pipeline

la version de Jenkins incluse par défaut dans les paquets Ubuntu est souvent inférieure à la dernière version disponible sur le projet en lui-même. Installez Jenkins en utilisant les paquets gérés par le projet pour être sûr de bien avoir les dernières corrections et fonctionnalités.

Tout d’abord, ajoutez la clé du référentiel au système :

    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

Une fois la clé ajoutée, le système affichera OK.

Ensuite, ajoutons l’adresse du référentiel Debian sur la sources.list​​​​​​ du serveur :

    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

Une fois les deux commandes saisies, nous exécuterons la update afin que apt utilise le nouveau référentiel.

    sudo apt update

Enfin, nous installerons Jenkins et ses dépendances.

    sudo apt install jenkins

Maintenant que Jenkins et ses dépendances sont installés, nous allons démarrer le serveur Jenkins.
     sudo systemctl start jenkins
