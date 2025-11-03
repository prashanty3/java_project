FROM openjdk:21-jdk-slim

WORKDIR /app

# Copy the built JAR (note the correct name from your pom.xml)
COPY target/tasks-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]