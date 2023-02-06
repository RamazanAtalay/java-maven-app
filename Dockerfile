FROM openjdk:8-jre-alpine

EXPOSE 8080

COPY ./target/java-maven-app-*.jar /usr/app/

WORKDIR /usr/app

ARG VERSION

ENV VERSION $VERSION

ARG BUILD_TIMESTAMP

ENV BUILD_TIMESTAMP $BUILD_TIMESTAMP

CMD java -jar java-maven-app-*.jar