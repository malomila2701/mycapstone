FROM frekele/ant:1.10.14-jdk17 AS build
WORKDIR /app
COPY . .
RUN ant clean dist

FROM tomcat:9-jdk17
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080