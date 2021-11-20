FROM gradle:jdk11-alpine AS build

RUN apk add bash && rm -rf /var/cache/apk/*

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build --no-daemon 

FROM openjdk:8-jre-slim

EXPOSE 8080

COPY --from=build /home/gradle/src/build/libs/*.jar /home/gradle/src/spring-boot-application.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/home/gradle/src/spring-boot-application.jar"]

