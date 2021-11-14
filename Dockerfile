FROM openjdk:8-jre-alpine

ARG JAR_FILE=target/java-maven-app-*.jar

COPY ${JAR_FILE} app.jar

ENTRYPOINT ["java", "-jar",  "/app.jar"]
