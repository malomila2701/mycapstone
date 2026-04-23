FROM tomcat:9-jdk17

# supprimer l’app par défaut
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# copier ton WAR
COPY dist/capstone_v1.war /usr/local/tomcat/webapps/ROOT.war

# lancer tomcat
CMD ["catalina.sh", "run"]