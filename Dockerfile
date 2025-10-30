# Use a lightweight Java 17 base image
FROM eclipse-temurin:17-jdk-jammy

# Set working directory
WORKDIR /app

# Install curl and unzip
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Download Snowstorm JAR
RUN curl -L -o snowstorm.jar https://github.com/IHTSDO/snowstorm/releases/download/9.2.0/snowstorm-9.2.0.jar

# Expose port (Railway replaces it automatically)
EXPOSE 8080

# Environment variables
ENV SPRING_DATA_MONGODB_URI=mongodb://localhost:27017/snowstorm
ENV DISABLE_ELASTICSEARCH=true

# --- FORCE disable Elasticsearch via Spring property ---
ENV SPRING_PROFILES_ACTIVE=no-elastic

# Create a config file that overrides Elasticsearch startup
RUN echo "disable-elasticsearch=true" > /app/application.properties && \
    echo "spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchDataAutoConfiguration" >> /app/application.properties && \
    echo "spring.main.allow-bean-definition-overriding=true" >> /app/application.properties

# Start Snowstorm on the Railway port, with explicit -D flag
CMD bash -lc "java -Dserver.port=\${PORT:-8080} -Ddisable-elasticsearch=true -Dspring.config.location=/app/application.properties -jar snowstorm.jar"
