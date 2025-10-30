# Use a lightweight Java 17 base image
FROM eclipse-temurin:17-jdk-jammy

# Set the working directory
WORKDIR /app

# Install curl and unzip (for downloading and extracting files)
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Download Snowstorm JAR (replace version if needed)
RUN curl -L -o snowstorm.jar https://github.com/IHTSDO/snowstorm/releases/download/9.2.0/snowstorm-9.2.0.jar

# Expose default port
EXPOSE 8080

# Default MongoDB URI (you’ll override this in Railway)
ENV SPRING_DATA_MONGODB_URI=mongodb://localhost:27017/snowstorm

# Disable Elasticsearch globally
ENV DISABLE_ELASTICSEARCH=true

# Run Snowstorm and force it to use Railway's dynamic $PORT and disable Elasticsearch
CMD ["bash", "-lc", "java -Dserver.port=${PORT:-8080} -Ddisable-elasticsearch=true -jar snowstorm.jar"]
