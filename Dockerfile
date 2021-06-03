FROM openjdk:8-jdk-alpine
LABEL maintainer="Bart Van Bos <bartvanbos@gmail.com>"

ARG JAR_FILE=application/target/*.jar

RUN apk add -U --no-cache bash curl openssl

COPY ${JAR_FILE} app.jar

ENV SERVER_PORT=8080
EXPOSE 8080

ENTRYPOINT ["java","-jar","/app.jar", "--server.port=${SERVER_PORT}"]
