FROM openjdk:17-jdk-slim

# create app directory
WORKDIR /app

# install curl for healthchecks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# download Snowstorm
ADD https://github.com/IHTSDO/snowstorm/releases/download/9.2.0/snowstorm-9.2.0.jar /app/snowstorm.jar

EXPOSE 8080

# use Postgres inside container for terminology index (or local storage)
ENV SPRING_DATA_MONGODB_URI=mongodb://localhost:27017/snowstorm

# NOTE: Snowstorm uses MongoDB by default; Railway doesn't provide Mongo.
# For light testing, you can use an embedded Mongo (see below) or external Mongo Atlas.

CMD ["java", "-jar", "/app/snowstorm.jar"]
