# PatBoot Dockerfile

FROM openjdk:17-jdk-slim

ARG VERSION

COPY assets/PatBoot-${VERSION}.jar /application.jar

EXPOSE 8080

CMD ["java", "-jar", "/application.jar", "--spring.profiles.active=stag"]
