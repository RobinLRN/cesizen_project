#Image de base : Node 22 
FROM node:22-alpine

#Dossier à l'intérieur de conteneur
WORKDIR /app

#Copie des fichiers package.json et package-lock.json
COPY package*.json ./

#Installation des dépendances de prod
RUN npm ci --omit=dev

#Copie du rest des fichiers
COPY . .

#Exposition du port 3000
EXPOSE 3000

#Commande pour lancer l'application
CMD ["node", "app.js"]