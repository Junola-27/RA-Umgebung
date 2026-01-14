# On part d'une image Linux légère (Debian)
FROM debian:bullseye-slim

# Mettre à jour et installer les outils nécessaires
# gcc-arm-linux-gnueabi : Le compilateur pour ARM 32-bit
# qemu-user : L'émulateur pour exécuter le programme ARM sur ton Mac
# build-essential : Pour avoir 'make' et les outils de base
RUN apt-get update && apt-get install -y \
    gcc-arm-linux-gnueabi \
    qemu-user \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Définir le dossier de travail dans le conteneur
WORKDIR /app

# Commande par défaut (shell)
CMD ["/bin/bash"]