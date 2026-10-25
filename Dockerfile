# Stage 1: Build WAR using Maven & JDK 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY uploads ./src/main/webapp/uploads
COPY data ./src/main/webapp/data
RUN mvn clean package -DskipTests

# Stage 2: Run on Apache Tomcat 10.1 + Built-in MariaDB Server
FROM tomcat:10.1-jdk21-temurin
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
COPY database.sql /docker-entrypoint-initdb.sql
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh && chmod +x /usr/local/bin/docker-entrypoint.sh
EXPOSE 8080
CMD ["/usr/local/bin/docker-entrypoint.sh"]
