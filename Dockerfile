# Use a lightweight Java 17 runtime
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install dependencies (curl + unzip)
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Download Snowstorm JAR (you can update to a newer version if released)
RUN curl -L -o snowstorm.jar https://github.com/IHTSDO/snowstorm/releases/download/9.2.0/snowstorm-9.2.0.jar

# Expose default port (Railway will override this automatically)
EXPOSE 8080

# Set MongoDB URI (will be replaced by Railway variable later)
ENV SPRING_DATA_MONGODB_URI=mongodb://localhost:27017/snowstorm

# Start Snowstorm and bind to Railway's dynamic port
CMD ["bash", "-lc", "java -Dserver.port=${PORT:-8080} -jar snowstorm.jar"]
