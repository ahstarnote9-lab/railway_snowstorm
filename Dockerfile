FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Get Snowstorm
ADD https://github.com/IHTSDO/snowstorm/releases/download/9.2.0/snowstorm-9.2.0.jar /app/snowstorm.jar

# Optional: smaller JVM footprints
ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Start script
RUN printf '%s\n' \
  '#!/bin/sh' \
  'set -eu' \
  'echo "Starting Snowstorm with ELASTIC_URL=${ELASTIC_URL:-<unset>}"' \
  'exec java -Dserver.address=0.0.0.0 -Dserver.port=${PORT:-8080} \' \
  '  -Delasticsearch.urls=${ELASTIC_URL} \' \
  '  ${ELASTIC_USERNAME:+-Delasticsearch.username=${ELASTIC_USERNAME}} \' \
  '  ${ELASTIC_PASSWORD:+-Delasticsearch.password=${ELASTIC_PASSWORD}} \' \
  '  -jar /app/snowstorm.jar' \
  > /app/start.sh && chmod +x /app/start.sh

EXPOSE 8080
ENTRYPOINT ["/app/start.sh"]
