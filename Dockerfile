FROM tomcat:9-jdk17

# install ant
RUN apt-get update && apt-get install -y ant

WORKDIR /app

# copy full project
COPY . .

# build WAR using Ant
RUN ant clean dist

# deploy WAR
RUN cp dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]