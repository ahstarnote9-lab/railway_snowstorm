FROM openjdk:17-jdk-slim

WORKDIR /app

# Install curl and unzip
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Download Snowstorm jar (use a stable release)
RUN curl -L -o snowstorm.jar https://github.com/IHTSDO/snowstorm/releases/download/9.2.0/snowstorm-9.2.0.jar

# Expose port
EXPOSE 8080

# Environment variable for MongoDB (you'll set this in Railway)
ENV SPRING_DATA_MONGODB_URI=mongodb://localhost:27017/snowstorm

CMD ["java", "-jar", "snowstorm.jar"]
