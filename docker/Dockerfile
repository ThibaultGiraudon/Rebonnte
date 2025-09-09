# Dockerfile pour Firebase Emulator
FROM node:18-bullseye

# Installer Java (nécessaire pour Firestore Emulator)
RUN apt-get update && \
    apt-get install -y openjdk-17-jre && \
    rm -rf /var/lib/apt/lists/*

# Installer Firebase CLI globalement
RUN npm install -g firebase-tools

# Créer un dossier de travail
WORKDIR /workspace

# Exposer les ports définis dans ton firebase.json
EXPOSE 9000 9010 9020 9030

# Lancer les émulateurs
CMD ["firebase", "emulators:start", "--project=gestionstockmedicaments-dd197"]
