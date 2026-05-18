FROM tomcat:9-jdk17

# remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# copy prebuilt WAR from GitHub repo
COPY dist/capstone_v1.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]