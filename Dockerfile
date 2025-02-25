# Utiliser une image Python officielle comme image de base
FROM python:3.12-slim

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Installer les dépendances système nécessaires
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    && apt-get clean

# Installer Poetry
RUN pip install --no-cache-dir poetry

# Copier les fichiers de configuration de Poetry
COPY pyproject.toml poetry.lock ./

# Installer les dépendances
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Copier le reste du code de l'application
COPY src/. .

# Exposer le port sur lequel l'application écoute
EXPOSE 80

# Définir la commande pour démarrer l'application avec Gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:80", "-t", "300", "index:app"]