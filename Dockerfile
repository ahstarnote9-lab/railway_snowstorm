# Use a lightweight Java 17 base image
FROM eclipse-temurin:17-jdk-jammy

# Set the working directory
WORKDIR /app

# Install curl and unzip (used for downloading and extracting files)
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Download Snowstorm JAR (replace version with newer if needed)
RUN curl -L -o snowstorm.jar https://github.com/IHTSDO/snowstorm/releases/download/9.2.0/snowstorm-9.2.0.jar

# Expose the default port (Railway will override this automatically)
EXPOSE 8080

# Set environment variable for MongoDB (you will override this in Railway variables)
ENV SPRING_DATA_MONGODB_URI=mongodb://localhost:27017/snowstorm

# Run Snowstorm and listen on Railway's assigned $PORT
ENTRYPOINT ["java", "-Dserver.port=${PORT:-8080}", "-jar", "snowstorm.jar"]
