FROM eclipse-temurin:17-jdk AS builder

# Installer Ant
RUN apt-get update && apt-get install -y ant

# Copier tout le projet
WORKDIR /app
COPY . .

# Clean et Build (génère le WAR)
RUN ant clean jar

# --- Image finale avec Tomcat ---
FROM tomcat:9-jdk17

# Supprimer l'app par défaut
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copier le WAR buildé depuis l'étape précédente
COPY --from=builder /app/dist/capstone_v1.war /usr/local/tomcat/webapps/ROOT.war

# Lancer Tomcat
CMD ["catalina.sh", "run"]